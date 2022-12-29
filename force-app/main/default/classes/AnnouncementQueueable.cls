/**
 * @name AnnouncementQueueable
 * @description This class posts Chatter Announcements
**/
public class AnnouncementQueueable implements Queueable {

    public List<ConnectApi.AnnouncementInput> toPost;

    public AnnouncementQueueable(List<ConnectApi.AnnouncementInput> toPost) {
        this.toPost = toPost;
    }
    //ToDo: Modify this class to implement the Queueable interface and call the postAnnouncements method


    /**
     * @name postAnnouncements
     * @description This method is provided for you to facilitate the Super Badge
    **/
    public static void PostAnnouncements(List<ConnectApi.AnnouncementInput> announcements) {
        while (announcements.size() > 0) {
            if (Limits.getDmlStatements() < Limits.getLimitDmlStatements() && !Test.isRunningTest()) {
                ConnectApi.AnnouncementInput a = announcements.remove(0);
                ConnectApi.Announcements.postAnnouncement('Internal', a);
            } else {
                break;
            }
        }
        if (announcements.size() > 0 && !Test.isRunningTest()) {
            AnnouncementQueueable q = new AnnouncementQueueable(announcements);
            q.toPost = announcements;
            System.enqueueJob(q);
            //ToDo: Enqueue the above instance of announcementQueueable
        }
    }

    public void execute(QueueableContext param1) {
        PostAnnouncements(toPost);
    }
}