#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
int main()
{
    pid_t pid;
    int status, exit_status;

    printf("The main program process ID is %d\n\n", getpid());
    printf("Callingforknow\n\n");
    //The return value to the parent process will be the Process ID(PID)of the child
    //The child gets a return value of 0

    if ((pid = fork()) < 0){
        perror("fork failed");
        exit(1);
    }
    /*child*/
    if(pid == 0)
    {
        printf("C: Child %d sleeping\n", getpid());
        sleep(4);
        _exit(5);//exit with a non zero value
    }
    while(waitpid(pid, &status, WNOHANG)==0){
        printf("Still waiting......\n");
        sleep(1);


    }
    if(WIFEXITED(status)){
        exit_status = WEXITSTATUS(status);
        printf("Exit status from process %d = %d\n",pid, exit_status);
    }
    else if (WIFSIGNALED(status)){
        exit_status = WTERMSIG(status);
        printf("Abnormal termination from process %d = %d\n",pid, exit_status);
    }

    exit(0);
}
