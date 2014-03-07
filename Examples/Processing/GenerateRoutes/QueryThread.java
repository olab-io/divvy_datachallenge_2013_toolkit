

public class QueryThread implements Runnable {
    private int i;

    QueryThread(int i) {
        this.i = i;
    }

    public void run() {
        System.out.println("Thread " + i + " going to sleep ... ");
        try {
            Thread.sleep((long) Math.random() * 5000 + 4000);
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        System.out.println("Thread " + i + " done.");

    }

    public String toString() {
        return "Thread=" + i;
    }
}

