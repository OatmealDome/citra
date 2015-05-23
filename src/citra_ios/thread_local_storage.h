#pragma once

#include <pthread.h>

template<typename T>
class thread_local_storage
{
private:
    pthread_key_t key;
    
public:
    thread_local_storage()
    {
        pthread_key_create(&key, NULL);
    }
    
    ~thread_local_storage()
    {
        pthread_key_delete(key);
    }
    
    thread_local_storage& operator =(T* p)
    {
        pthread_setspecific(key, p);
        return *this;
    }
    
    bool operator !()
    {
        return pthread_getspecific(key) == NULL;
    }
    
    T* operator ->()
    {
        return static_cast<T*>(pthread_getspecific(key));
    }
    
    T* get()
    {
        return static_cast<T*>(pthread_getspecific(key));
    }
};