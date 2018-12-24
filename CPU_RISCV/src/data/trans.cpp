#include <bits/stdc++.h>
using namespace std;

char ram[1 << 17];

int to_dec(char x){
	if (x >= '0' & x <= '9')
		return x - '0';
	else
		return x - 'a' + 10;
}

int main(){
	freopen("test.data", "r", stdin);
	freopen("test.v", "w", stdout);
	int addr = 0;
	string str = "";
	while(cin >> str){
		if (str[0] == '@'){
			addr = 0;
			for(int i = 1; i <= 8; i++)
				addr = addr * 16 + to_dec(str[i]);
		}
		else{
			printf("ram[%d] <= 8'h%s;\n", addr++, str.c_str());
		}
	}
	
	fclose(stdin);
	fclose(stdout);
	return 0;
}
