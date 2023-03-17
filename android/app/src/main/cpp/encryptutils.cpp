#include <stdio.h>
#include <string.h>
#include<stdlib.h>
#include <jni.h>


char* getpassword() {
    
    char const *src="zlcnffjbeq";
    if(src == NULL){
      return NULL;
    }

    char* result = (char*)malloc(strlen(src));

    if(result != NULL){
      strcpy(result, src);
      char* current_char = result;

      while(*current_char != '\0'){
        //Only increment alphabet characters
        if((*current_char >= 97 && *current_char <= 122) || (*current_char >= 65 && *current_char <= 90)){
          if(*current_char > 109 || (*current_char > 77 && *current_char < 91)){
            //Characters that wrap around to the start of the alphabet
            *current_char -= 13;
          }else{
            //Characters that can be safely incremented
            *current_char += 13;
          }
        }
        current_char++;
      }
    }
    printf("%s",result);
    //jstring jstrBuf = env->NewStringUTF(result);

    return result;
}


