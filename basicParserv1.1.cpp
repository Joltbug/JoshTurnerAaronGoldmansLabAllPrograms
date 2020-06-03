#include <string>
#include <ctype.h>
#include <iostream>
#include <fstream>
#include <algorithm>

using namespace std;

string beforeTab(string input);
string afterTab(string input);
string beforeSpace(string input);
string afterSpace(string input);
boolean getGenusSpecies(string line, string &Genus, String &Species);

int main(){
	
	//this part enables access to the input file of BLAST output
	//will throw an error if the file named doesn’t exist
	//this file is where all of the information used to get results comes from, so its important
	//the cutoffs are what section of the results to search, probably determined by coverage
	ifstream file;
	file.open("Blast2Result");
	

	string genuses[10] = {};
	string species[10] = {};
	string accessionNum[10] = {};
	string currentGenus = "";
	string currentSpecies =" ";
	string currentNum = " ";
	int resultCount = 0;
	bool genusFound;
	bool speciesFound;
	bool numberFound;
	string placeholder;
	
	for(int i = 0; i< 100; i++)
	{	
		if(resultCount<10){
			getline(file, placeholder);
			currentNum = beforeTab(afterTab(placeholder));
			placeholder = afterTab(afterTab(placeholder));
			currentGenus = "";
			currentSpecies = "";
			genusFound = false;
			if(getGenusSpecies(placeholder,currentGenus,currentSpecies))genusFound = true;
			for(int j = 0; j<10; j++){
				if(currentGenus == genuses[j]){
					genusFound = true;
				}
			}
			if(!genusFound){
				genuses[resultCount] = currentGenus;
				accessionNum[resultCount] = currentNum;
				species[resultCount] = currentSpecies;
				resultCount++;
			}
		}
	}
	for(int i = 0; i< 100; i++)
	{
		
		if(resultCount<10){
			getline(file, placeholder);
			currentNum = beforeTab(afterTab(placeholder));
			placeholder = afterTab(afterTab(placeholder));
			currentGenus = "";
                        currentSpecies = "";
                        speciesFound = false;
                        if(getGenusSpecies(placeholder,currentGenus,currentSpecies))speciesFound = true;
			for(int j = 0; j<10; j++){
				if(currentSpecies == species[j]){
					speciesFound = true;
				}
			}
			if(!speciesFound){
				genuses[resultCount] = currentGenus;
				accessionNum[resultCount] = currentNum;
				species[resultCount] = currentSpecies;
				resultCount++;
			}
		}
	}

	for(int i =0; i<10; i++){
		if(resultCount<10){
			getline(file, placeholder);
			currentNum = beforeTab(afterTab(placeholder));
			placeholder = afterTab(afterTab(placeholder));
			currentGenus = "";
                        currentSpecies = "";
			bool useless = getGenusSpecies(placeholder,currentGenus,currentSpecies);
			for(int j = 0; j<10; j++){
				if(currentNum == accessionNum[j]){
					numberFound = true;
				}
			}
			if(!numberFound){
				genuses[resultCount] = currentGenus;
				accessionNum[resultCount] = currentNum;
				species[resultCount] = currentSpecies;
				resultCount++;
			}
		}
	}

	ofstream results;
	results.open("parserResults");

	for (int i = 0; i<resultCount; i++){
		results << accessionNum[i] << '\t' << genuses[i] << species[i] << endl;
	}

	results.close();
	
	return 0;
}

string beforeTab(string input){
	string before = "";
	bool space = true;
	//declare variables
	for(int i = 0; i< input.size();i++){
		if(space){
			before = before + input[i];
		}
		if(input[i] == '\t'){
                        space = false;
                        //check if there is a whitespace character then disable adding chars to the result
                }
	}
	return before;
}

string afterTab(string input){
	string after = "";
	bool space = false;
	for(int i = 0; i< input.size();i++){
		if(space){
			after = after + input[i];
		}
		if(input[i] == '\t'){
                        space = true;
                        //check if there is a whitespace character then enable adding chars to the result                }
                }
	}
	return after;
}

string beforeSpace(string input){
	string before = "";
	bool space = true;
	//declare variables
	for(int i = 0; i< input.size();i++){
		if(space){
			before = before + input[i];
		}
		if(input[i] == ' '){
                        space = false;
                        //check if there is a whitespace character then disable adding chars to the result
                }
	}
	return before;
}

string afterSpace(string input){
	string after = "";
	bool space = false;
	for(int i = 0; i< input.size();i++){
		if(space){
			after = after + input[i];
		}
		if(input[i] == ' '){
                        space = true;
                        //check if there is a whitespace character then disable adding chars to the result
                }
	}
	return after;
}

boolean getGenusSpecies(string line, string &Genus, String &Species){
	boolean GorS = true;
	boolena done = false;
	int i = 0;
	char current = '';
	char last = ' ';	
	while(i<line.size() && !done){
		current = line[i];
		if((last== ' ')&&(islower(current))){
			GorS = false;
		}
		if((!GorS)&&((current== ' ')||(current = ';'))){
			done = true;		
		}
		else{
			if(GorS){
				Genus += Genus+current;
			}
			else{
				Species = Species+current;
			}
		}
		last = line[i];
	}
	if(Genus.isEmpty)return false;
	for(int j= 0; j< Species.size();j++){
		if(!isalpha(Species[i])) return false; 
	}
	return true;
}

