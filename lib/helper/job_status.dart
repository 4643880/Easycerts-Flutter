class JobStatus {
  static String unAssigned = "0";
  static String jobCompleted = "1";
  static String accepted = "2";
  static String rejected = "3";
  static String startTravelling = "4";
  static String arriveAtSite = "5";
  static String noAccess = "6";
  static String startJob = "7";
  static String leaveSite = "8";
  static String arriveAtSiteAfterParts = "9";
  static String noAccessAfterParts = "10";
  static String resumeJob = "11";
  static String assignedJob = "12";
  static String pendingPayment = "14";
  static String inspectionCompleted = "15";
  static String pauseJob = "16";
  static String cancelJob = "17";

  static String returnJobStatus(int value) {
    switch (value) {
      case 0:
        {
          return "Unassigned";
        }
      case 1:
        {
          return "Completed";
        }
      case 2:
        {
          return "Accepted";
        }
      case 3:
        {
          return "Rejected";
        }
      case 4:
        {
          return "Travelling towards site";
        }
      case 5:
        {
          return "Arrived at site";
        }
      case 6:
        {
          return "No Access";
        }
      case 7:
        {
          return "In Progress";
        }
      case 8:
        {
          return "Leave Site";
        }
      case 9:
        {
          return "Arrive At Site After Parts";
        }
      case 10:
        {
          return "No Access After Parts";
        }
      case 11:
        {
          return "In Progress";
        }
      case 12:
        {
          return "Not Accepted";
        }
      case 14:
        {
          return "Pending Payment";
        }
      case 15:
        {
          return "Inspection Completed";
        }
      case 16:
        {
          return "Job is paused";
        }
      case 17:
        {
          return "Cancel Job";
        }
      default:
        {
          return "Unknown";
        }
    }
  }

  static String returnJobStatusUpdateMessage(int value) {
    switch (value) {
      case 0:
        {
          return "";
        }
      case 1:
        {
          return "";
        }
      case 2:
        {
          return "User selected accept visit.";
        }
      case 3:
        {
          return "User rejected this visit.";
        }
      case 4:
        {
          return "User selected start travelling.";
        }
      case 5:
        {
          return "User selected arrived at site.";
        }
      case 6:
        {
          return "User no access to this visit.";
        }
      case 7:
        {
          return "User selected start visit.";
        }
      case 8:
        {
          return "";
        }
      case 9:
        {
          return "";
        }
      case 10:
        {
          return "";
        }
      case 11:
        {
          return "User selected resume visit after pause.";
        }
      case 12:
        {
          return "";
        }
      case 14:
        {
          return "";
        }
      case 15:
        {
          return "";
        }
      case 16:
        {
          return "User selected pause visit.";
        }
      case 17:
        {
          return "";
        }
      default:
        {
          return "";
        }
    }
  }
}
