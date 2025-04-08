import os 
os.environ['PATH'] = "/usr/local/cuda/bin:$PATH"
os.environ['LD_LIBRARY_PATH']="/usr/local/cuda-11.7/lib64:$LD_LIBRARY_PATH"
os.environ['GPU_INCLUDE_PATH']="/usr/local/cuda-11.7/include"
os.environ['GPU_LIBRARY_PATH']="/usr/local/cuda-11.7/lib64"
