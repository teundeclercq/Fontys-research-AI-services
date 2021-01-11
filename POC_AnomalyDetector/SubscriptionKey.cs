using System;
using System.Collections.Generic;
using System.Text;

namespace AnomalyDetector
{
    public static class SubscriptionKey
    {
        public static string getSubscriptionKeyAnamolyDetector()
        {
            return "SUBSCRIPTION__KEY";
        }

        public static string getEndPointAnamolyDetector()
        {
            return "https://anomalydemo1.cognitiveservices.azure.com/";
        }
    }
}
