CanaryFinder
============
![alt tag](http://t0.gstatic.com/images?q=tbn:ANd9GcRl8eDgK88bSzNSPZfiXBIK7bNC4sScz725ZTOViYHDKDEM7mIcXA)


Most of the compilers today add the /GS cookie compiler option by default, however in some cases if the compiler identifies that the function does not contain string manipulation or character arrays not more that a certain length Stack cookie is not enabled, This project aims at finding whether the stack cookie is enabled for all functions in the binary or not.

[+] Added support for checking Canary in ELF Files on Linux Platform

Usage: CanaryFinder [OPTION]

Options:

  --file <ELF File>
  --ver
  --help

For more info, please see my project page on:
Achin Kulshrestha, @Geekmonk
http://www.achin.in



[+] The Windows Code is not stable yet. Need to add more checks.

![alt tag](http://t0.gstatic.com/images?q=tbn:ANd9GcRl8eDgK88bSzNSPZfiXBIK7bNC4sScz725ZTOViYHDKDEM7mIcXA)
