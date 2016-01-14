/*
 *  Ferret.cpp
 *  Ferret
 *
 *  Created by Andrew(Zhiyong) Yang on 1/14/16.
 *  Copyright © 2016 FoolDragon. All rights reserved.
 *
 */

#include <iostream>
#include "Ferret.hpp"
#include "FerretPriv.hpp"

void Ferret::HelloWorld(const char * s)
{
	 FerretPriv *theObj = new FerretPriv;
	 theObj->HelloWorldPriv(s);
	 delete theObj;
};

void FerretPriv::HelloWorldPriv(const char * s) 
{
	std::cout << s << std::endl;
};

