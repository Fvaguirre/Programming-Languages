package hw12;

public class Cache {
	Account m_act;
	int start_val;
	int curr_val;
	int read_cache = 0;
	boolean isOpen = false;
	boolean isWritten = false;
	boolean isRead = false;
	
	public Cache(Account act) {
		this.m_act = act;
		this.start_val = this.m_act.peek();
		this.curr_val = this.start_val;
	}
	
	//verify act with curr val
	public void verify() throws TransactionAbortException{
		if (this.isRead) {
			this.m_act.verify(this.start_val);
		}
	}
	
	//get curr val
    public int peek() {
        this.isRead = true;
        return this.curr_val;
    }
	//open act to modify
	public void open() throws TransactionAbortException{
		try {
			if (this.isRead) {
				this.m_act.open(false);
				this.isOpen = true;
			}
			if (this.isWritten) {
				this.m_act.open(true);
				this.isOpen = true;
			}
		}
		catch (TransactionUsageError e) {
			System.out.println("TransactionUsageError at cache open");
		}
	}
	
	//close act if open
	public void close() {
		if(this.isOpen) {
			try {
				this.m_act.close();
			}
			catch (TransactionUsageError e){
				System.out.println("TransactionUsageError at cache close");
			}
		}
	}
	
	//if writing is needed then update act
	public void check_update() {
		if (this.isWritten) {
			this.m_act.update(this.curr_val);
		}
	}
	
	//update cache to new val
	public void update(int new_val) {
		this.curr_val = new_val;
		this.isWritten = true;
	}
	
	
}
