#include<cstdio>
#include<cstring>
#include<iostream>
#include<queue>
using namespace std;
const int N=101010;
int hex_map[256];
char memory[1024 * 128];
int reg[32];

int main(){
	string str, last;
	cin >> last;
	while (cin >> str){
		if (str == last || str == "pc:00000000::00000000" || str[0] != 'p')
			continue;
		last = str;
		cout << str << endl;
	}
}


