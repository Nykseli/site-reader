#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <netdb.h>

// TODO: get the addr with a DNS
int main(void) {
    struct sockaddr_in sa;

    memset(&sa, 0, sizeof sa);

    sa.sin_family = AF_INET;
    sa.sin_port = htons(80);
    inet_pton(AF_INET, "31.217.196.211", &sa.sin_addr);

    uint8_t* sa_ptr = (uint8_t*)&sa;
    for (int i = 0; i < sizeof sa; i++) {
        printf("0x%02x", sa_ptr[i]);
        if (i < 15) {
            printf(", ");
        }
    }

    printf("\n");

   /*  int sfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sfd == -1) {
      perror("cannot create socket");
      exit(EXIT_FAILURE);
    }
    if (connect(sfd, (struct sockaddr *)&sa, sizeof sa) == -1) {
      perror("connect failed");
      close(sfd);
      exit(EXIT_FAILURE);
    }
 */
    return 0;
}
