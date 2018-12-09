package hw12;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;

// TO DO: Task is currently an ordinary class.
// You will need to modify it to make it a task,
// so it can be given to an Executor thread pool.
//
class Task implements Runnable {
    private static final int A = constants.A;
    private static final int Z = constants.Z;
    private static final int numLetters = constants.numLetters;

    private Account[] accounts;
    private String transaction;

    // TO DO: The sequential version of Task peeks at accounts
    // whenever it needs to get a value, and opens, updates, and closes
    // an account whenever it needs to set a value.  This won't work in
    // the parallel version.  Instead, you'll need to cache values
    // you've read and written, and then, after figuring out everything
    // you want to do, (1) open all accounts you need, for reading,
    // writing, or both, (2) verify all previously peeked-at values,
    // (3) perform all updates, and (4) close all opened accounts.

    public Task(Account[] allAccounts, String trans) {
        accounts = allAccounts;
        transaction = trans;
    }
    
    // TO DO: parseAccount currently returns a reference to an account.
    // You probably want to change it to return a reference to an
    // account *cache* instead.
    //
    private cache parseAccount(String name, cache[] Cache) {
        int accountNum = (int) (name.charAt(0)) - (int) 'A';
        if (accountNum < A || accountNum > Z)
            throw new InvalidTransactionError();
        cache a = Cache[accountNum];
        for (int i = 1; i < name.length(); i++) {
            if (name.charAt(i) != '*')
                throw new InvalidTransactionError();
            accountNum = (Cache[accountNum].read() % numLetters);
            a = Cache[accountNum];
        }
        return a;
    }

    private int parseAccountOrNum(String name, cache[] Cache) {
        int rtn;
        if (name.charAt(0) >= '0' && name.charAt(0) <= '9') {
            rtn = new Integer(name).intValue();
        } else {
            rtn = parseAccount(name, Cache).read();
        }
        return rtn;
    }

    public void run() {
        // tokenize transaction
    	while (true) {
    		String[] commands = transaction.split(";");
            cache[] Cache = new cache[26];
            for (int i = A; i <= Z; i++) {
            	Cache[i] = new cache(accounts[i]);
            }
            for (int i = 0; i < commands.length; i++) {
                String[] words = commands[i].trim().split("\\s");
                if (words.length < 3)
                    throw new InvalidTransactionError();
                cache lhs = parseAccount(words[0], Cache);
                if (!words[1].equals("="))
                    throw new InvalidTransactionError();
                int rhs = parseAccountOrNum(words[2], Cache);
                for (int j = 3; j < words.length; j+=2) {
                    if (words[j].equals("+"))
                        rhs += parseAccountOrNum(words[j+1], Cache);
                    else if (words[j].equals("-"))
                        rhs -= parseAccountOrNum(words[j+1], Cache);
                    else
                        throw new InvalidTransactionError();
                }
                	lhs.write(rhs);
            }
            boolean broken = false;
            for (int i = A; i <= Z; i++) {
            	try {
            		Cache[i].commit();
            	} catch(TransactionAbortException e) {
            		broken = true;
            		accounts[i].close();
            	}
            }
            if (broken == true) {
            	continue;
            }
    	}
        
    }
}

public class MultithreadedServer {

	// requires: accounts != null && accounts[i] != null (i.e., accounts are properly initialized)
	// modifies: accounts
	// effects: accounts change according to transactions in inputFile
    public static void runServer(String inputFile, Account accounts[])
        throws IOException {

        // read transactions from input file
        String line;
        BufferedReader input =
            new BufferedReader(new FileReader(inputFile));

        // TO DO: you will need to create an Executor and then modify the
        // following loop to feed tasks to the executor instead of running them
        // directly.
        
        ExecutorService executorServ = Executors.newFixedThreadPool(5);
        
        while ((line = input.readLine()) != null) {
            Task t = new Task(accounts, line);
            executorServ.execute(t);
        }
        
        input.close();

    }
}
