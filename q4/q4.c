#include <stdio.h>
#include <dlfcn.h>
int main(){
    while(1){
        int a, b;
        char str[10];
        if(scanf("%s %d %d",str,&a,&b)!=3){
            break;
        }//some way to break the loop and also forced upon by ai
        char so[20];
        snprintf(so,20,"./lib%s.so",str);
        void* ponting=dlopen(so, RTLD_LAZY);
        int(*funk)(int,int)=(int(*)(int,int)) dlsym(ponting,str);
        printf("%d\n",funk(a,b));
        dlclose(ponting);
    }
}
