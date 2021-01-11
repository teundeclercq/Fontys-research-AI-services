using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Microsoft.CognitiveServices.Speech;
using Microsoft.CognitiveServices.Speech.Audio;
using Microsoft.CognitiveServices.Speech.Translation;

namespace SpeechPOC
{
    class Program
    {
        static readonly string SPEECH__SUBSCRIPTION__KEY = "SUBSCRIPTION__KEY";

        static readonly string SPEECH__SERVICE__REGION = "westeurope";

        static Task Main() => TranslateSpeechAsync();

        static async Task TranslateSpeechAsync()
        {
            var translationConfig =
        SpeechTranslationConfig.FromSubscription(SPEECH__SUBSCRIPTION__KEY, SPEECH__SERVICE__REGION);

            var fromLanguage = "nl-NL";
            var toLanguages = new List<string> { "en", "fr", "de", "es", "fi", "nb" };
            //var toLanguages = new List<string> { "en" };
            translationConfig.SpeechRecognitionLanguage = fromLanguage;
            toLanguages.ForEach(translationConfig.AddTargetLanguage);

            using var recognizer = new TranslationRecognizer(translationConfig);

            Console.Write($"Say something in '{fromLanguage}' and ");
            Console.WriteLine($"we'll translate into '{string.Join("', '", toLanguages)}'.\n");

            var result = await recognizer.RecognizeOnceAsync();
            if (result.Reason == ResultReason.TranslatedSpeech)
            {
                Console.WriteLine($"Recognized: \"{result.Text}\":");
                foreach (var (language, translation) in result.Translations)
                {
                    if (language == "en")
                    {
                        using var synthesizer = new SpeechSynthesizer(translationConfig);
                        await synthesizer.SpeakTextAsync(translation);
                    }

                    Console.WriteLine($"Translated into '{language}': {translation}");
                }
            }
        }
    }
}
