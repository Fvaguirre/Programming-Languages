package hw12;

public class cache {
	private Account account;
	private int val = 0;
	private boolean read;
	private boolean write;
	
	public cache(Account acc) {
		account = acc;
		val = acc.getValue();
		read = false;
		write = false;
	}
	
	public int getVal() {
		int copy = val;
		return copy;
	}
	
	//three methods, write, read
	public int read() {
		read = true;
		int value = val;
		return value;
	}
	
	public void write(int v) {
		write = true;
		val = v;
	}
	
	public boolean getRead() {
		boolean copy = read;
		return copy;
	}
	
	public boolean getWrite() {
		boolean copy = write;
		return copy;
	}
	
	public void commit() throws TransactionAbortException {
		boolean open = true;
		if (read == true) {
			account.open(false);
			account.verify(val);
		}
		if (write == true) {
			account.open(true);
			account.update(val);
		}
		if (open == true) {
			account.close();
			open = false;
		}
	}
}
