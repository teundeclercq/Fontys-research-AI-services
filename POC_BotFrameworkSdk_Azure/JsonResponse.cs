using System;
using Newtonsoft.Json;

namespace TeamsConversationBot
{

    [JsonObject(MemberSerialization = MemberSerialization.OptIn)]
    public class JsonResponse
    {
        [JsonProperty(PropertyName = "id")]
        public int id {get;set;}

        [JsonProperty(PropertyName = "name")]
        public string name { get; set; }

        [JsonProperty(PropertyName = "start_at")]
        public DateTime start_at { get; set; }


        [JsonProperty(PropertyName = "created_at")]
        public DateTime created_at { get; set; }

        [JsonProperty(PropertyName = "course_code")]
        public string course_code { get; set; }

        [JsonProperty(PropertyName = "account_id")]
        public string account_id { get; set; }


    }
}
