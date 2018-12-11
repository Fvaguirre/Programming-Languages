package hw12;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class MultiThreadedTask implements Runnable {
	private String transaction;
	private Account[] accounts;
	private Cache[] caches;
	
	
	
	//Constructor
	public MultiThreadedTask(String trans, Account[] acts) {
		this.caches = new Cache[acts.length];
		this.transaction = trans;
		this.accounts = acts;
	}
	
	//Get cache ref
	private Cache parseAccount(String name) {
        int accountNum = (int) (name.charAt(0)) - (int) 'A';
        if (accountNum < constants.A || accountNum > constants.Z)
            throw new InvalidTransactionError();
        Cache a = this.caches[accountNum];
        for (int i = 1; i < name.length(); i++) {
            if (name.charAt(i) != '*')
                throw new InvalidTransactionError();
            accountNum = (this.caches[accountNum].peek() % constants.numLetters);
            a = this.caches[accountNum];
            //ADDED
//            a.isRead = true;
        }
        return a;
    }
	 private int parseAccountOrNum(String name) {
	        if (name.charAt(0) >= '0' && name.charAt(0) <= '9') {
	            return Integer.parseInt(name);
	        } else {
	            return parseAccount(name).peek();
	        }
	    }
	
	 
	 private void loadAccounts() {
		 for (int i=0; i < this.accounts.length; i++) {
			 this.caches[i] = new Cache(this.accounts[i]);
		 }
	 }
	 
	 private void runTransaction() {
		 String[] commands = this.transaction.split(";");
	        for (String command : commands) {
	            String[] words = command.trim().split("\\s");
	            if (words.length < 3)
	                throw new InvalidTransactionError();
	            Cache lhs = parseAccount(words[0]);
	            if (!words[1].equals("=")) {
	                throw new InvalidTransactionError();
	            }
	            int rhs = parseAccountOrNum(words[2]);
	            for (int j = 3; j < words.length; j += 2) {
	                if (words[j].equals("+")) {
	                    rhs += parseAccountOrNum(words[j + 1]);
	                }
	                else if (words[j].equals("-")) {
	                    rhs -= parseAccountOrNum(words[j + 1]);
	                }
	                else {

	                    throw new InvalidTransactionError();
	                }
	            }
	            lhs.update(rhs);
	        }
	 }
	 
	 private void closeAccounts() {
		 for (Cache c : this.caches) {
			 c.close();
		 }
	 }
	 
@Override
public void run() {
	 	int abort = 1;
		 while(abort == 1) {
			 abort = 0;
			 loadAccounts();
			 runTransaction();
			 
			 try {
				 for(int i=constants.A; i <= constants.Z; i++) {
					 Cache accCache = this.caches[i];
					 accCache.open();
					 
				 }
			 }
			 catch (TransactionAbortException e) {
				 System.out.println("Account failed to open");
				 this.closeAccounts();
				 continue;
			 }
			 try {
	             for (Cache c : this.caches) {
	            	 c.verify();
	                }
	            } 
			 	catch (TransactionAbortException e) {
	                System.out.println("Account verification failed");
	                this.closeAccounts();
	                abort = 1;
	            }
	            for (int i = constants.A; i <= constants.Z; i++) {
	            	Cache c = this.caches[i];
	            	c.check_update();
	            	c.close();
	            }
	            System.out.println("commit: " + this.transaction);
	            break;

	        }
		 }
}