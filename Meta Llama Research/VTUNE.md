# INTEL VTUNE

"Installing VTUNE via https://www.intel.com/content/www/us/en/docs/vtune-profiler/installation-guide/2023-0/package-managers.html

Dr.Li has assigned us to use Intel VTUne on llama.cpp's perplexity tool.

Here is his tasks.

- analyze the hotspot functions of Perplexity: what are the hot functions which consume most of the CPU cycles? and what's their functionality (understanding the source code)?
- analyze the potential performance bottleneck, by following some tutorials here.
- use Intel TMA approach to analyze where memory accesses are bounded.

## Plan of action

- [Setting up the Intel VTune](https://www.intel.com/content/www/us/en/docs/vtune-profiler/get-started-guide/2023/linux-os.html) ignore step number 2 because we don't have control over how perplexity is compiled.

- Extra help [Intel VTune CheatSheet ](https://www.intel.com/content/dam/develop/external/us/en/documents/vtune-profiler-cheat-sheet.pdf)

Currently trying to complete the tutorial

- Go to this [Intel VTune tutorial](https://www.intel.com/content/www/us/en/developer/articles/training/vtune-profiler-tutorials.html)
