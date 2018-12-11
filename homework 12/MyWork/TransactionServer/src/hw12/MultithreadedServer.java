package hw12;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.concurrent.*;



public class MultithreadedServer {
		// requires: accounts != null && accounts[i] != null (i.e., accounts are properly initialized)
		// modifies: accounts
		// effects: accounts change according to transactions in inputFile
	public static void runServer(String inputFile, Account accounts[])
		throws IOException {
	    // read transactions from input file
	    System.out.println(inputFile);
	    String line;
	    BufferedReader input =
	    	new BufferedReader(new FileReader(inputFile));

	    int numThreads = 10;
	    ExecutorService exec = Executors.newFixedThreadPool(numThreads);
	    while ((line = input.readLine()) != null) {
	    	MultiThreadedTask t = new MultiThreadedTask(line, accounts);
	            exec.execute(t);
	    }
	    exec.shutdown();
	    try {
	    	exec.awaitTermination(60,TimeUnit.SECONDS);
	    }
	    catch(InterruptedException e) {}
	    input.close();
	    }
	}
	


