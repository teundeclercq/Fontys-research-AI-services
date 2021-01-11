using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace AnomalyDetector
{
    public class AnomalyDetectorTest
    {
        //This sample assumes you have created an environment variable for your key and endpoint
        static readonly string subscriptionKey = SubscriptionKey.getSubscriptionKeyAnamolyDetector();
        static readonly string endpoint = SubscriptionKey.getEndPointAnamolyDetector();

        // Replace the dataPath string with a path to the JSON formatted time series data.
        const string dataPath = "MOCK_DATA.json";

        const string latestPointDetectionUrl = "/anomalydetector/v1.0/timeseries/last/detect";
        const string batchDetectionUrl = "/anomalydetector/v1.0/timeseries/entire/detect";



        static async Task<string> Request(string apiAddress, string endpoint, string subscriptionKey, string requestData)
        {
            using (HttpClient client = new HttpClient { BaseAddress = new Uri(apiAddress) })
            {
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", subscriptionKey);

                var content = new StringContent(requestData, Encoding.UTF8, "application/json");
                var res = await client.PostAsync(endpoint, content);
                return await res.Content.ReadAsStringAsync();
            }
        }

        static void detectAnomaliesBatch(string requestData)
        {
            Console.WriteLine("Detecting anomalies as a batch");

            //construct the request
            var result = Request(
                endpoint,
                batchDetectionUrl,
                subscriptionKey,
                requestData).Result;

            //deserialize the JSON object, and display it
            dynamic jsonObj = Newtonsoft.Json.JsonConvert.DeserializeObject(result);
            System.Console.WriteLine(jsonObj);

            if (jsonObj["code"] != null)
            {
                Console.WriteLine($"Detection failed. ErrorCode:{jsonObj["code"]}, ErrorMessage:{jsonObj["message"]}");
            }
            else
            {
                //Find and display the positions of anomalies in the data set
                bool[] anomalies = jsonObj["isAnomaly"].ToObject<bool[]>();
                System.Console.WriteLine("\nAnomalies detected in the following data positions:");
                for (var i = 0; i < anomalies.Length; i++)
                {
                    if (anomalies[i])
                    {
                        Console.Write(i + ", ");
                    }
                }
            }
        }


        static void detectAnomaliesLatest(string requestData)
        {
            Console.WriteLine("\n\nDetermining if latest data point is an anomaly");
            //construct the request
            var result = Request(
                endpoint,
                latestPointDetectionUrl,
                subscriptionKey,
                requestData).Result;

            //deserialize the JSON object, and display it
            dynamic jsonObj = Newtonsoft.Json.JsonConvert.DeserializeObject(result);
            Console.WriteLine(jsonObj);
        }

        static void Main(string[] args)
        {
            //read in the JSON time series data for the API request
            var requestData = File.ReadAllText(dataPath);

            detectAnomaliesBatch(requestData);
            detectAnomaliesLatest(requestData);
            System.Console.WriteLine("\nPress any key to exit ");
            System.Console.ReadKey();
        }
    }
}

