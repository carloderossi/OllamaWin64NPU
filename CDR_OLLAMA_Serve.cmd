@echo off
REM ================================
REM Ollama Environment Configuration
REM ================================

REM Set environment variables for this session only

:: Controls how many requests Ollama can process simultaneously.
:: 	Default (1): Only one request runs at a time. This avoids contention and is best for interactive use.
:: 	When to raise it: If you plan to run multiple prompts concurrently (e.g. benchmarking or serving multiple clients), you could set it to  or higher.
:: 	Trade‑off: Higher values can increase throughput but may slow down individual responses because resources are shared.
set OLLAMA_NUM_PARALLEL=1
::set OLLAMA_NUM_PARALLEL=4

:: Limits how many models Ollama keeps in memory at once.
:: Default (2): Up to two models can be loaded simultaneously.
:: When to lower it: If you want to conserve RAM/VRAM and only ever use one model, set it to 1
:: When to raise it: If you frequently switch between models (e.g. Qwen3 and Llama3), keeping  avoids reload delays.
set OLLAMA_MAX_LOADED_MODELS=2

::set OLLAMA_MAX_QUEUE=128
set OLLAMA_MAX_QUEUE=4

::  With a 16‑core CPU + Arc GPU, you can safely raise this (e.g. 8 or 12).
:: set OLLAMA_NUM_THREADS=8
::set OLLAMA_NUM_THREADS=4
:: Thread count: experiment with OLLAMA_NUM_THREADS=12
set OLLAMA_NUM_THREADS=12

REM Persist GPU/NPU settings across sessions
setx OLLAMA_USE_GPU 1
setx OLLAMA_DEVICE xpu

set OLLAMA_NUM_GPU=999
set ZES_ENABLE_SYSMAN=1

set OLLAMA_DEBUG=ERROR
:: set OLLAMA_DEBUG=WARN

:: Default is 512. Lowering it reduces latency for interactive prompts, though it may slightly reduce throughput.
set OLLAMA_BATCH_SIZE=256

:: Controls how long a model stays resident in memory after a request.
:: Default is 5m0s (five minutes).
:: If you set it to "-1", the model will stay loaded indefinitely until you stop the server.
set OLLAMA_KEEP_ALIVE=-1

REM ================================
REM Start the Ollama server in background
REM ================================
start "" ollama serve

REM ================================
REM Run Qwen3 model
REM ================================
ollama run qwen3:1.7b

