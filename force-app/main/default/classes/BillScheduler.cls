public with sharing class BillScheduler implements Schedulable {
    public void execute(SchedulableContext ctx) {
        BillBatch bb = new BillBatch();
        Database.executeBatch(bb);
    }
}