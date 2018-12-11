package hw12.test;

import hw12.*;

import java.io.*;
import java.lang.Thread.*;
import java.util.Arrays;
import java.util.HashSet;
import java.util.concurrent.*;
import java.util.Random;

import junit.framework.TestCase;

import org.junit.Test;

public class MultithreadedServerTests extends TestCase {
    private static final int A = constants.A;
    private static final int Z = constants.Z;
    private static final int numLetters = constants.numLetters;
    private static Account[] accounts;
            
    protected static void dumpAccounts() {
	    // output values:
	    for (int i = A; i <= Z; i++) {
	       System.out.print("    ");
	       if (i < 10) System.out.print("0");
	       System.out.print(i + " ");
	       System.out.print(new Character((char) (i + 'A')) + ": ");
	       accounts[i].print();
	       System.out.print(" (");
	       accounts[i].printMod();
	       System.out.print(")\n");
	    }
	 }    
     
    Account[] initAccounts() {
    	// initialize accounts 
    	accounts = new Account[numLetters];
    	for (int i = 0; i <= Z; i++) {
    		this.accounts[i] = new Account(Z-i);
    	}
    	return accounts;
    }
    private void verifyResults(String test_file) throws IOException {
    	Account[] singleThreadAccounts = initAccounts();
    	Account[] multiThreadAccounts = initAccounts();
    	
    	System.out.println("Running singlethreaded test.");
		SinglethreadedServer.runServer(test_file, singleThreadAccounts);

		System.out.println("Running multithreaded test.");
		MultithreadedServer.runServer(test_file,multiThreadAccounts);
		
		for (int i = 0; i <= Z; i++) {
			Character c = new Character((char) (i+'A'));
			System.out.println("Account  "+c+" : Single is " + Integer.toString(singleThreadAccounts[i].getValue())+ "; Multi is " + Integer.toString(multiThreadAccounts[i].getValue()));
			assertEquals("Account "+c+" differs", singleThreadAccounts[i].getValue(), multiThreadAccounts[i].getValue());

		}
    }
     @Test
	 public void testIncrement() throws IOException {
	
    	this.accounts = initAccounts();
		
		MultithreadedServer.runServer("hw12/data/increment", accounts);
	
		// assert correct account values
		for (int i = A; i <= Z; i++) {
			Character c = new Character((char) (i+'A'));
			assertEquals("Account "+c+" differs",Z-i+1,accounts[i].getValue());
		}		

	 }
     
     @Test
	 public void testStudent() throws IOException {
    	 verifyResults("hw12/data/student_test_case");
	 }
     
//     @Test
//     public void testRotate() throws IOException {
//    	 verifyResults("hw12/data/rotate");

//     }
     @Test
     public void testRotate2() throws IOException {
    	 verifyResults("hw12/data/rotate2");
     }

 	 	  
	 	  	 
	
}