#!/bin/bash
#Script made by Adam for automatic setup of files for llama testing

echo "chmod 777 /tdata"
sudo chmod 777 /tdata

#absolute path to /tdata
echo "Moving into /tdata"
cd /tdata
echo "Cloning 4 Directories at once..."

#clone llama github
echo "cloning Meta's LLama github"
git clone https://github.com/facebookresearch/llama.git &

#clone llama.cpp github
echo "cloning LLama.cpp github"
git clone https://github.com/ggerganov/llama.cpp.git &

#clone cmake github
echo "cloning CMAKE github needed for intel pcm tools"
git clone https://github.com/Kitware/CMake.git &

#clone intel pcm tools github
echo "Cloning intel pcm tools needed for monitoring perplexity"
git clone --recursive https://github.com/opcm/pcm.git &

wait


echo "Changing tmp Directory to be inside tdata"
TMPDIR=/tdata/tmp

#META related commands
echo "Moving into Meta Directory"
cd llama/

echo "Installing Python Pip"
sudo apt install python3-pip
pip install -e .               #install everything

echo "The next command requires user input. Please grab the link for the META model that recieved after filling in the form in the link below."
echo "https://ai.meta.com/resources/models-and-libraries/llama-downloads/"
echo "Choose the model 7B after inputting the email link."
read -p "Press any key to continue..." -n1 -s

#This bash script inside the llama directory asks for a link from the email
./download.sh


#LLAMA CPP Related
echo "Making inside LLama.cpp folder"
cd ../llama.cpp
make

echo "Moving Downloaded Llama Items over into models folder"
cd ./models
mv ../../llama/tokenizer_checklist.chk ./
mv ../../llama/tokenizer_checklist.chk ./
mv ../../llama/llama-2-7b ./

echo "Installing Python Dependencies in Llama.cpp root directory"
cd ..
python3 -m pip install -r requirements.txt

echo "Converting llama-2-7b folder into ggml FP16 format"
python3 convert.py models/llama-2-7b/

echo "Backing up before Quantizing model"
cp ./models/llama-2-7b ./models/llama-backup -r

echo "Quantizing"
./quantize ./models/llama-2-7b/ggml-model-f16.gguf ./models/llama-2-7b/ggml-model-q4_0.gguf q4_0

echo "Downloading Perplexity test dataset."
wget https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-2-raw-v1.zip?ref=salesforce-research

echo "Unzipping wikitext-2-raw-v1.zip"
unzip 'wikitext-2-raw-v1.zip?ref=salesforce-research'

echo "Completed all LLama.cpp related Tasks."

#INTEL PCM AND CMAKE
echo "Building CMAKE tools and Intel PCM"
echo "Building CMAKE tools" #CMAKE is necessary to build INTEL PCM
cd /tdata/CMake
./bootstrap && make && sudo make install

echo "Building Intel PCM"
cd /tdata/pcm

mkdir build

cd build

cmake ..

cmake --build .

#INTEL VTUNE
echo "Installing VTUNE via https://www.intel.com/content/www/us/en/docs/vtune-profiler/installation-guide/2023-0/package-managers.html"
cd /tdata
wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
sudo apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
rm GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
echo "deb https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list
sudo apt update
sudo apt install intel-oneapi-vtune