using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.CognitiveServices.Language.SpellCheck;
using Microsoft.Azure.CognitiveServices.Language.SpellCheck.Models;
using System.Net.Http;
using System.Net.Http.Headers;
using Newtonsoft.Json;

namespace BingSearch
{
    public class SpellCheck
    {

        static string host = "https://api.cognitive.microsoft.com";
        static string path = "/bing/v7.0/spellcheck?";
        static string key = SubscriptionKey.getSpellingCheckKey();
        //text to be spell-checked
        static string text = "Hollo, wrld!";

        static string params_ = "mkt=en-US&mode=proof";


        public static async Task SpellChecking()
        {
            string uri = host + path + params_;

            var client = new HttpClient();
            client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", key);

            HttpResponseMessage response = null;

            var values = new Dictionary<string, string>();
            values.Add("text", text);
            var content = new FormUrlEncodedContent(values);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/x-www-form-urlencoded");
            response = await client.PostAsync(uri, new FormUrlEncodedContent(values));


            string client_id;
            if (response.Headers.TryGetValues("X-MSEdge-ClientID", out IEnumerable<string> header_values))
            {
                client_id = header_values.First();
                Console.WriteLine("Client ID: " + client_id);
            }

            string contentString = await response.Content.ReadAsStringAsync();

            dynamic jsonObj = JsonConvert.DeserializeObject(contentString);
            Console.WriteLine(jsonObj);

        }
    }
}
