#include<stdio.h>
#include<unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
    pid_t pid;
    int status;
    int tmp=10;

    printf("The main program process ID is %d\n\n", getpid());
    printf("Callingforknow\n\n");
    //The return value to the parent process will be the Process ID(PID)of the child
    //The child gets a return value of 0

    pid=fork();
    printf("fork has been called, pid returned is %d\n",pid);


    if(pid == 0)
    {
        printf("C: This is the child process: %d\n", pid);
        printf("C: The value of getpid is : %d\n", getpid());
        printf("C: The value of getppid is : %d\n", getppid());
        tmp++;
        printf("%d\n",tmp);
    }
    else if(pid > 0)
    {

        wait(&status);
        printf("Waiting on child.......\n");
        printf("P: This is the parent process: %d\n",pid);
        printf("P: The value of getpid is : %d\n", getpid());
        printf("P: The value of getppid is : %d\n", getppid());
        printf("%d\n",tmp);
    }
    else

        printf("Forkfailed, no child\n");


return 0;

}
