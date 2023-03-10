//
// Created by kai on 02/02/23.
//

#pragma once

#ifndef VERLET_CUDAMEMORY_CUH
#define VERLET_CUDAMEMORY_CUH

#include "../common/definitions.hpp"
#include <cstdio>

#define CUDA_CALL(CALL) if (CALL != cudaSuccess) { printf("CUDA call failed at %s:%i\n", __FILE__,__LINE__); exit(-1); }

template<typename T>
class CudaMemory {
public:
    explicit CudaMemory(size_t array_length) {
        CUDA_CALL(cudaMalloc(&this->devPtr, sizeof(T) * array_length));
        this->hostPtr = (T*)(malloc(sizeof(T) * array_length));
        memset(this->hostPtr, 0, array_length);
        this->N = array_length;
    }

    CudaMemory() {
        CUDA_CALL(cudaMallocManaged(&this->devPtr, sizeof(T)));
        this->hostPtr = (T*)malloc(sizeof(T));
        memset(this->hostPtr, 0, 1);
        this->N = 1;
    }

    ~CudaMemory() {
        CUDA_CALL(cudaFree(this->devPtr))
        free(this->hostPtr);
    }

    T* getPointer() {
        return this->hostPtr;
    }

    T* getDevicePointer() {
        return this->devPtr;
    }

    void send() {
        CUDA_CALL(cudaMemcpy(this->devPtr, this->hostPtr, sizeof(T) * this->N, cudaMemcpyHostToDevice));
    }

    void sync() {
        CUDA_CALL(cudaMemcpyAsync(this->hostPtr, this->devPtr, sizeof(T) * this->N, cudaMemcpyDeviceToHost));
    }

    void sync_to_async(T** ptr) {
        CUDA_CALL(cudaMemcpyAsync(*ptr, this->devPtr, sizeof(T) * this->N, cudaMemcpyDeviceToHost));
    }

    void sync_to(T** ptr) {
        CUDA_CALL(cudaMemcpy(*ptr, this->devPtr, sizeof(T) * this->N, cudaMemcpyDeviceToHost));
    }

    T& operator[](size_t idx) {
        return this->hostPtr[idx];
    }

    size_t size() {
        return this->N * sizeof(T);
    }

private:
    T* hostPtr;
    T* devPtr;
    size_t N;
};

#endif //VERLET_CUDAMEMORY_CUH
