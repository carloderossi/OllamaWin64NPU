# OllamaWin64GPU-NPU
How to run Ollama using the Intel NPU on a windows Notebook
End‑to‑end setup, optimization, and IPEX‑LLM integration

This README consolidates everything from our exploration of:

- Running **Ollama on Windows 11** with an **Intel Arc GPU**
- Tuning **batch size, threads, keep‑alive, and loaded models**
- Understanding **Ollama processes** (`ollama.exe`, `ollama-lib.exe`, `ollama app.exe`)
- Using **lighter models** for responsiveness
- How **IPEX‑LLM** fits into Intel GPU/NPU acceleration and portable Ollama builds
- Verifying **NPU support** and enabling Intel GPU/NPU runtimes

It is written to be dropped directly into a GitHub repository as `README.md`.

---

## 1. Hardware & software context

- **OS:** Windows 11
- **GPU:** Intel Arc (SYCL backend, oneAPI runtime)
- **CPU:** Multi‑core Intel CPU (16 cores / 22 threads)
- **AI runtime:** Ollama with GGUF models (Qwen3, Llama 3.2, DeepSeek, etc.)
- **Acceleration:**
  - Intel Arc GPU via **SYCL** (used by `llama.cpp`‑based runtimes)
  - Potential Intel NPU acceleration via **IPEX‑LLM** (BigDL) for compatible chips

---

## 2. IPEX‑LLM on Windows (Intel GPU/NPU acceleration)

### 2.1 What IPEX‑LLM is

**IPEX‑LLM** is an Intel‑backed LLM acceleration library under the BigDL project. It is designed to optimize LLM inference (and in some cases training) across Intel hardware:

- **GPU:** Integrated and discrete Intel GPUs (Arc, Flex, Max)  
- **NPU:** NPUs on Intel Core Ultra CPUs  
- **CPU:** Optimized Xeon and client CPUs

Recent versions (e.g. 2.2.0) add:

- Support for **Intel GPU** in PyTorch 2.6
- Ability to run very large models with **Arc A770** GPUs
- **Portable `llama.cpp` and Ollama bundles** targeted at Intel GPU/NPU

This means you can either:

- Use **Ollama’s own SYCL backend** (what we did here), or  
- Use **IPEX‑LLM portable builds** of `llama.cpp`/Ollama if you want a fully Intel‑optimized stack.

### 2.2 IPEX‑LLM Quickstart for Windows (conceptual)

At a high level, an IPEX‑LLM quickstart on Windows looks like:

1. **Install Intel GPU/NPU drivers** (Arc, oneAPI, and NPU where applicable).  
2. **Install Python and IPEX‑LLM** (via pip or conda, depending on Intel docs).  
3. Use their **pre‑built portable `llama.cpp` or Ollama archives** for Intel hardware, which include binaries linked against Intel’s SYCL/oneAPI stack.  
4. Launch models through these portable runtimes or via a custom Python backend that offloads work to GPU/NPU.

For pure Ollama usage, the key takeaway is:  
> Intel provides **portable builds** of `llama.cpp`/Ollama tuned for Intel GPU/NPU via IPEX‑LLM.  

If you rely on those, you’d choose the **Windows portable package** matching your hardware (Intel GPU / NPU) from Intel’s IPEX‑LLM or BigDL distribution.

---

## 3. Verifying NPU support on Windows

On a Windows system with an Intel NPU (e.g., Core Ultra):

1. **Check Device Manager**  
   - Look under **System devices** or a dedicated **NPU** section.
   - You should see an **Intel NPU** entry if your CPU supports it and drivers are installed.

2. **Confirm with Intel tools / drivers**  
   - Ensure the Intel NPU driver and associated runtime are installed (often shipped via OEM or Intel driver packages).  
   - Some guides use `dxdiag` or Intel tools to confirm presence and compatibility.

3. **Understand Ollama’s NPU story**  
   - As of now, mainstream tools like **Ollama** and LM Studio **do not natively offload to NPU**; they target CPU/GPU. This is why some setups use **IPEX‑LLM + custom backends** to tap the NPU.  
   - For NPU‑first usage, you likely need an **IPEX‑LLM Python backend** bridging to a UI (e.g., Open WebUI).

For this README, the working configuration uses **Intel Arc GPU**, not NPU, as the Ollama accelerator.

---

## 4. Enabling Intel GPU/NPU runtime for Ollama

### 4.1 Intel GPU (Arc) via SYCL

Ollama’s `llama.cpp` backend detects Intel GPUs and uses **SYCL**. In logs you see:

- `using device SYCL0 (Intel(R) Arc(TM) Graphics)`  
- `offloading XX/XX layers to GPU`  

To ensure Ollama prefers the Intel GPU:

```cmd
setx OLLAMA_USE_GPU 1
setx OLLAMA_DEVICE xpu
```
look in the Ollama logs for
```cmd
using device SYCL0 (Intel(R) Arc(TM) Graphics)
Found 1 SYCL devices:
Intel Arc Graphics
offloaded 29/29 layers to GPU
```

