import java.util.List;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class QueryThreadPoolExecutor {
  int corePoolSize = 2;
  int maximumPoolSize = 2;
  long keepAliveTime = 5;

  ThreadPoolExecutor threadPool = null;

  final ArrayBlockingQueue<Runnable> queue = new ArrayBlockingQueue<Runnable>(30);

  public QueryThreadPoolExecutor() {
    threadPool = new ThreadPoolExecutor(corePoolSize, maximumPoolSize, keepAliveTime, TimeUnit.SECONDS, 
    queue);
  }

  public void runTask(Runnable task) {
    System.out.println("1. Task count.." + threadPool.getTaskCount());
    System.out.println("2. Queue Size before assigning the task.." + queue.size());
    threadPool.execute(task);
    System.out.println("3. Queue Size after assigning the task.." + queue.size());
    System.out.println("4. Pool Size after assigning thetask.." + threadPool.getActiveCount());
    System.out.println("5. Task count.. TP: " + threadPool.getTaskCount());
    System.out.println("6. Task count.. QS: " + queue.size());
    System.out.println("-------------------");
  }

  public void shutDown() {
    //        threadPool.shutdown();
    List<Runnable> stillThere = threadPool.shutdownNow();
    for (Runnable r : stillThere) {
      System.out.println("Quit: " + r);
    }
  }

//  public static void main(String args[]) {
//    QueryThreadPoolExecutor mtpe = new MyThreadPoolExecutor();
//
//    for (int i = 0; i < 40; i++)
//      mtpe.runTask(new MyThread(i));
//
//    try {
//      Thread.sleep(60*1000);
//    } 
//    catch (InterruptedException e) {
//      // TODO Auto-generated catch block
//      e.printStackTrace();
//    }
//
//    mtpe.shutDown();
//  }
}

