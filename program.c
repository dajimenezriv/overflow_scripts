#include <stdio.h>
#include <unistd.h>
 
int vuln() {

	char buf[87];

	int r = read(0, buf, 400);

	printf("%s", buf);

	return 0;

}

int main(int argc, char *argv[]) {

	return vuln();

}
