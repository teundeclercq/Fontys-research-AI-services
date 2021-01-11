using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TeamsConversationBot
{
    // Defines a state property used to track information about the user.
    public class UserProfile
    {
        public string Name { get; set; }
        public string userID { get; set; }
        public string courseID { get; set; }

        public string status { get; set;}


    }
}
