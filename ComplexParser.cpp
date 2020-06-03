#include <string>
#include <ctype.h>
#include <iostream>
#include <fstream>
#include <algorithm>

using namespace std;

// COMMENT THIS PROGRAM SO THAT WHEN YOU LEAVE IT ISN’T USELESS

int lastUsable(string inFileName, int minQ);
void cogAdd(string cogNum);
string beforeTab(string input);
string afterTab(string input);
string beforeSpace(string input);
string afterSpace(string input);
bool getGenusSpecies(string line, string& Genus, string& Species);
bool resultChooserBaseOutput(string inFileName, string outFileName, int cutoffB, int cutoffE);
int stringToInt(string toInt);
bool resultChooserPython(string inFileName, string outFileName, int cutoffB, int cutoffE);

//Naming convention for input data COG####_SuperFamily_SuperPhyla_BlastResults
//Naming convention for COG####_SuperFamily_SuperPhyla_verboseSelection
//SuperPhylya is one of Archea, Bacteria, eukaryota, mitochondrion, or plastid
//SuperPhyla can be recipblast which meant searching the archea sequence in bacteria and vice versa

string Outputs[53] ={
		"_Archea_Asgard_verboseSelection", 
	"_Archea_DPANN_verboseSelection",
	"_Archea_Euryarchaeota_verboseSelection",
	"_Archea_TACK_verboseSelection",
	"_Bacteria_Acidobacteria_verboseSelection",
	"_Bacteria_Aquificae_verboseSelection",
	"_Bacteria_Balneolaeota_verboseSelection",
	"_Bacteria_Caldiscerica_verboseSelection",
	"_Bacteria_Chrysiogenetes_verboseSelection",
	"_Bacteria_Deferribacteres_verboseSelection",
	"_Bacteria_Dictyoglomi_verboseSelection",
	"_Bacteria_Elusimicrobia_verboseSelection",
	"_Bacteria_FCB_verboseSelection",
	"_Bacteria_Fusobacteria_verboseSelection",
	"_Bacteria_Tectomicrobia_verboseSelection",
	"_Bacteria_Nitrospirae_verboseSelection",
	"_Bacteria_Proteobacteria_verboseSelection",
	"_Bacteria_PVC_verboseSelection",
	"_Bacteria_Rhodothermaeota_verboseSelection",
	"_Bacteria_Spirochaetes_verboseSelection",
	"_Bacteria_Synergistetes_verboseSelection",
	"_Bacteria_Terrabacteria_verboseSelection",
	"_Bacteria_Thermodesulfobacteria_verboseSelection",
	"_Bacteria_Thermototage_verboseSelection",
	"_Eukaryota_Alveota_verboseSelection",
	"_Eukaryota_Amoebozoa_verboseSelection",
	"_Eukaryota_Apusozoa_verboseSelection",
	"_Eukaryota_Breviatea_verboseSelection",
	"_Eukaryota_Centroheliozoa_verboseSelection",
	"_Eukaryota_Ctyptophyta_verboseSelection",
	"_Eukaryota_Euglenozoa_verboseSelection",
	"_Eukaryota_Fornicata_verboseSelection",
	"_Eukaryota_Glaucocystophyceae_verboseSelection",
	"_Eukaryota_Haptophyceae_verboseSelection",
	"_Eukaryota_Heterolobosea_verboseSelection",
	"_Eukaryota_Jakobida_verboseSelection",
	"_Eukaryota_Malawimonadidae_verboseSelection",
	"_Eukaryota_Opisthokonta_verboseSelection",
	"_Eukaryota_Oxymonadida_verboseSelection",
	"_Eukaryota_Parabasalia_verboseSelection",
	"_Eukaryota_Rhizaria_verboseSelection",
	"_Eukaryota_Rhodophyta_verboseSelection",
	"_Eukaryota_Stramenopiles_verboseSelection",
	"_Eukaryota_Viridiplantae_verboseSelection",
	"_Mitochondrion_Euglenozoa_verboseSelection",
	"_Mitochondrion_Amoebozoa_verboseSelection",
	"_Mitochondrion_Opisthokonta_verboseSelection",
	"_Mitochondrion_Viridiplantae_verboseSelection",
	"_Plastid_Rhodophyta_verboseSelection",
	"_Plastid_Rhizaria_verboseSelection",
	"_Plastid_Viridiplantae_verboseSelection",
	"_Archea_recipBlast_verboseSelection",
	"_Bacteria_recipBlast_verboseSelection"
	};
string Inputs[53] ={
	"_Archea_Asgard_BlastResults",
	"_Archea_DPANN_BlastResults",
	"_Archea_Euryarchaeota_BlastResults",
	"_Archea_TACK_BlastResults",
	"_Bacteria_Acidobacteria_BlastResults",
	"_Bacteria_Aquificae_BlastResults",
	"_Bacteria_Balneolaeota_BlastResults",
	"_Bacteria_Caldiscerica_BlastResults",
	"_Bacteria_Chrysiogenetes_BlastResults",
	"_Bacteria_Deferribacteres_BlastResults",
	"_Bacteria_Dictyoglomi_BlastResults",
	"_Bacteria_Elusimicrobia_BlastResults",
	"_Bacteria_FCB_BlastResults",
	"_Bacteria_Fusobacteria_BlastResults",
	"_Bacteria_Tectomicrobia_BlastResults",
	"_Bacteria_Nitrospirae_BlastResults",
	"_Bacteria_Proteobacteria_BlastResults",
	"_Bacteria_PVC_BlastResults",
	"_Bacteria_Rhodothermaeota_BlastResults",
	"_Bacteria_Spirochaetes_BlastResults",
	"_Bacteria_Synergistetes_BlastResults",
	"_Bacteria_Terrabacteria_BlastResults",
	"_Bacteria_Thermodesulfobacteria_BlastResults",
	"_Bacteria_Thermototage_BlastResults",
	"_Eukaryota_Alveota_BlastResults",
	"_Eukaryota_Amoebozoa_BlastResults",
	"_Eukaryota_Apusozoa_BlastResults",
	"_Eukaryota_Breviatea_BlastResults",
	"_Eukaryota_Centroheliozoa_BlastResults",
	"_Eukaryota_Ctyptophyta_BlastResults",
	"_Eukaryota_Euglenozoa_BlastResults",
	"_Eukaryota_Fornicata_BlastResults",
	"_Eukaryota_Glaucocystophyceae_BlastResults",
	"_Eukaryota_Haptophyceae_BlastResults",
	"_Eukaryota_Heterolobosea_BlastResults",
	"_Eukaryota_Jakobida_BlastResults",
	"_Eukaryota_Malawimonadidae_BlastResults",
	"_Eukaryota_Opisthokonta_BlastResults",
	"_Eukaryota_Oxymonadida_BlastResults",
	"_Eukaryota_Parabasalia_BlastResults",
	"_Eukaryota_Rhizaria_BlastResults",
	"_Eukaryota_Rhodophyta_BlastResults",
	"_Eukaryota_Stramenopiles_BlastResults",
	"_Eukaryota_Viridiplantae_BlastResults",
	"_Mitochondrion_Euglenozoa_BlastResults",
	"_Mitochondrion_Amoebozoa_BlastResults",
	"_Mitochondrion_Opisthokonta_BlastResults",
	"_Mitochondrion_Viridiplantae_BlastResults",
	"_Plastid_Rhodophyta_BlastResults",
	"_Plastid_Rhizaria_BlastResults",
	"_Plastid_Viridiplantae_BlastResults",
	"_Archea_recipBlast_BlastResults",
	"_Bacteria_recipBlast_BlastResults"
	};

int main(){
	
	// check the config file for the prefix of all files to look for
	ifstream config;
	config.open("config.txt");
	string placeholder;
	getline(config, placeholder);
	int slash = placeholder.rfind('/');
	placeholder = placeholder.substr(slash,placeholder.size());	
	cogAdd(placeholder);
	
	int sixtyQuery = 0;
	int thirtyQuery= 0;
	for(int i=0; i<52; i++){
		//try to find 10 results of >60 query coverage
		sixtyQuery = lastUsable(Inputs[i],60);
		if(!resultChooserPython(Inputs[i],Outputs[i],0,sixtyQuery)){
			// if 10 not found try to find 10 results of >30 query coverage
			thirtyQuery = lastUsable(Inputs[i],30);
			if(!resultChooserPython(Inputs[i],Outputs[i],sixtyQuery,thirtyQuery)){
				cout << "Less than 10 sequences found for "<<Inputs[i]<< endl;
			}	
		}
	}

	return 0;
}

void cogAdd(string cogNum){
	for(int i=0; i<52; i++){
		Inputs[i] = cogNum+ Inputs[i];
		Outputs[i] = cogNum+ Outputs[i];
	}
}
int lastUsable(string inFileName, int minQ){

	//go through the file and return the line number of the first query value below the given minQ  
	ifstream file;
	file.open(inFileName.c_str());
	string placeholderQuery = "";
	string placeholder;
	int qValue = 0;
	int usableCounter;
	while(getline(file , placeholder)){
		placeholderQuery = beforeTab(placeholder);
		qValue = stringToInt(placeholderQuery);
		// I wanted to use stoi here but the cluster did not have c++11, or a similar problem
		if(qValue>=minQ){
			usableCounter++;
		}
	}
	file.close();
}

int stringToInt(string toInt){
	
	//convert astring to a number, using the place value of the chars
	int out = 0;
	int digitMag = 1;
	for(int i = toInt.size(); i>0; i--){
		if(isalpha(toInt[i] ==0)){
			out = out + (toInt[i]- 0)* digitMag;
			digitMag = digitMag * 10;
		}
	}
	return out;
}

bool resultChooserPython(string inFileName, string outFileName, int cutoffB, int cutoffE){

        //this part enables access to the input file of BLAST output
        //will throw an error if the file named doesn’t exist
        //this file is where all of the information used to get results comes from, so its important
        //the cutoffs are what section of the results to search, probably determined by coverage
        ifstream file;
        file.open(inFileName.c_str());

	//The point of this huge block of initializations is to create 3 arrays of 10 final results.
	//Each array contains one important type of information for all 10 results, such as the accession number
	//These arrays are initialized to contain 10 empty strings
	//The int resultCount keeps track of how many results have been added, when it reaches 10 no more results are added.
        string genuses[11] = {};
        genuses[0] = "UNKNOWN";
        string species[11] = {};
        species[0] = "sp.";
	string qcovs[10] = {};
        string accessionNum[10] = {};
        string currentGenus = "";
        string currentSpecies =" ";
        string currentNum = " ";
	string qcov = "";
        int resultCount = 1;
        bool genusFound;
        bool speciesFound;
        bool numberFound;
        string placeholder;

	//this for loop searches through the blast results and tries to find results with 10 different genuses
	//if it runs into a result that has a genus not in the genuses array it will record it.
        for(int i = cutoffB; i< cutoffE; i++)
        {
                if(resultCount<11){
                        getline(file, placeholder);
			qcov = beforeTab(placeholder);
                        currentNum = beforeTab(afterTab(placeholder));
                        placeholder = afterTab(afterTab(placeholder));
                        genusFound = false;
			currentGenus = beforeTab(placeholder);
                        currentSpecies = afterTab(placeholder);
                        for(int j = 0; j<11; j++){
                                if(currentGenus == genuses[j]){
                                        genusFound = true;
                                }
                        }
                        if(!genusFound){
				qcovs[resultCount-1] = qcov;
                                genuses[resultCount] = currentGenus;
                                accessionNum[resultCount-1] = currentNum;
                                species[resultCount] = currentSpecies;
                                resultCount++;
                        }
                }
        }
	
	file.close();
        file.open(inFileName.c_str());

	//this for loop searches through the blast results and tries to find results with 10 different species
	//if it runs into a result that has a species not in the species array it will record it.
	for(int i = cutoffB; i< cutoffE; i++)
        {

                if(resultCount<11){
                        getline(file, placeholder);
			qcov = beforeTab(placeholder);
                        currentNum = beforeTab(afterTab(placeholder));
                        placeholder = afterTab(afterTab(placeholder));
			currentGenus = beforeTab(placeholder);
                        currentSpecies = afterTab(placeholder);
			speciesFound = false;
                        for(int j = 0; j<11; j++){
                                if(currentSpecies == species[j]){
                                        if(currentGenus == genuses[j]){
                                                speciesFound = true;
                                        }
                                }
                        }
                        if(!speciesFound){
				qcovs[resultCount-1] = qcov;
                                genuses[resultCount] = currentGenus;
                                accessionNum[resultCount-1] = currentNum;
                                species[resultCount] = currentSpecies;
                                resultCount++;
                        }
                }
        }
	
	file.close();
        file.open(inFileName.c_str());

	//after trying to find a variety of results then just take the first ten results this assumes the results are sorted by best cover
	//if it encounters a result that has an accession number not in the accession number array it records it
        for(int i =0; i<10; i++){
                if(resultCount<11){
                        getline(file, placeholder);
			qcov = beforeTab(placeholder);
                        currentNum = beforeTab(afterTab(placeholder));
                        placeholder = afterTab(afterTab(placeholder));
                        currentGenus = beforeTab(placeholder);
                        currentSpecies = afterTab(placeholder);
                        for(int j = 0; j<10; j++){
                                if(currentNum == accessionNum[j]){
                                        numberFound = true;
                                }
                        }
                        if(!numberFound){
				qcovs[resultCount-1] = qcov;
                                genuses[resultCount] = currentGenus;
                                accessionNum[resultCount-1] = currentNum;
                                species[resultCount] = currentSpecies;
                                resultCount++;
                        }
                }
        }

	//open the two output files, one for data on the chosen results, one for just the raw FASTA data
	file.close();
        ofstream results;
        results.open(outFileName.c_str());

	//write to the output files for the each of the results
        for (int i = 1; i<resultCount; i++){
                results << qcovs[i-1] << '\t' << accessionNum[i-1] << '\t' << genuses[i+1] << species[i+1] << endl;
        }

	results.close();

	//return true if 10 results were found
	if(resultCount>10){
		return true;
	}
	return false;
}


bool resultChooserBaseOutput(string inFileName, string outFileName, int cutoffB, int cutoffE){
		
	//this part enables access to the input file of BLAST output
	//will throw an error if the file named doesn’t exist
	//this file is where all of the information used to get results comes from, so its important
	//the cutoffs are what section of the results to search, probably determined by coverage
	ifstream file;
	file.open(inFileName.c_str());
	
	//The point of this huge block of initializations is to create 3 arrays of 10 final results.
	//Each array contains one important type of information for all 10 results, such as the accession number
	//These arrays are initialized to contain 10 empty strings
	//The int resultCount keeps track of how many results have been added, when it reaches 10 no more results are added.
	string genuses[11] = {};
	genuses[0] = "UNKNOWN";
	string species[11] = {};
	species[0] = "sp.";
	string accessionNum[10] = {};
	string currentGenus = "";
	string currentSpecies =" ";
	string currentNum = " ";
	int resultCount = 1;
	bool genusFound;
	bool speciesFound;
	bool numberFound;
	string placeholder;
	
	//this for loop searches through the blast results and tries to find results with 10 different genuses
	//if it runs into a result that has a genus not in the genuses array it will record it.
	for(int i = cutoffB; i< cutoffE; i++)
	{	
		if(resultCount<11){
			getline(file, placeholder);
			currentNum = beforeTab(afterTab(placeholder));
			placeholder = afterTab(afterTab(placeholder));
			currentGenus = "";
			currentSpecies = "";
			genusFound = false;
			if(!getGenusSpecies(placeholder,currentGenus,currentSpecies)){
				genusFound = true;
			}
			for(int j = 0; j<11; j++){
				if(currentGenus == genuses[j]){
					genusFound = true;
				}
			}
			if(!genusFound){
				genuses[resultCount] = currentGenus;
				accessionNum[resultCount-1] = currentNum;
				species[resultCount] = currentSpecies;
				resultCount++;
			}
		}
	}
	
	file.close();
	file.open(inFileName.c_str());
	
	//this for loop searches through the blast results and tries to find results with 10 different species
	//if it runs into a result that has a species not in the species array it will record it.		
	for(int i = cutoffB; i< cutoffE; i++)
	{
		
		if(resultCount<11){
			getline(file, placeholder);
			currentNum = beforeTab(afterTab(placeholder));
			placeholder = afterTab(afterTab(placeholder));
			currentGenus = "";
                        currentSpecies = "";
                        speciesFound = false;
                        if(!getGenusSpecies(placeholder,currentGenus,currentSpecies)){
				speciesFound = true;
			}
			for(int j = 0; j<11; j++){
				if(currentSpecies == species[j]){
					if(currentGenus == genuses[j]){
						speciesFound = true;
					}
				}
			}
			if(!speciesFound){
				genuses[resultCount] = currentGenus;
				accessionNum[resultCount-1] = currentNum;
				species[resultCount] = currentSpecies;
				resultCount++;
			}
		}
	}
	
	file.close();
        file.open(inFileName.c_str());
	
	//after trying to find a variety of results then just take the first ten results this assumes the results are sorted by best cover
	//if it encounters a result that has an accession number not in the accession number array it records it
	for(int i =0; i<10; i++){
		if(resultCount<11){
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
				accessionNum[resultCount-1] = currentNum;
				species[resultCount] = currentSpecies;
				resultCount++;
			}
		}
	}

	//open the two output files, one for data on the chosen results, one for just the raw FASTA data	
	file.close();
	ofstream results;
	results.open(outFileName.c_str());

	//write to the output files for the each of the results
	for (int i = 0; i<resultCount-1; i++){
		results << accessionNum[i] << '\t' << genuses[i+1] << species[i+1] << endl;
	}

	results.close();

	//return true if 10 results were found
        if(resultCount>10){ 
                return true;
        }
        return false;
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

bool getGenusSpecies(string line, string& Genus, string& Species){

	//This method uses the captialization of the words to separate them
	//based off the idea that species is usually the first lowercase word
	//in general this method is ineffective, using nother script to get good results is better

	string blacklist[] =
	{
	"archaeon",
	"bacterium",
	"sp.",
	};
	bool GorS = true;
	bool done = false;
	int i = 0;
	char current = ' ';
	char last = ' ';	
	while(i<line.size() && !done){
		current = line[i];
		if((last== ' ')&&(islower(current))){
			GorS = false;
		}
		if((!GorS)&&((current== ' ')||(current == ';'))){
                        done = true;
                }
		else{
			if(GorS){
				Genus += current;
			}
			else{
				Species += current;
			}
		}
		last = line[i];
		i++;
	}

	if(Genus.empty())return false;

	for( int j = 0; j<3; j++){
                if(Species ==  blacklist[j]) return false;
        }

	for(int j= 0; j< Species.size();j++){
		if(!isalpha(Species[j])) return false; 
	}
	return true;
}
