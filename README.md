#  PG5601 - iOS Programmering
## av Thomas Jacobsen Sourianos
### Kandidatnummer: 2031

### Kodereferanser:

- https://github.com/jrasmusson/swift-arcade/blob/master/CoreData/2-NSFetchedResultsController.md
-- Brukte dette git-repoet som en referanse på hvordan man skal sette opp en NSFetchedResultsController, slik at det ble enkelt å lage TableView basert på CoreData-modellen i prosjektet.

- https://rderik.com/blog/solutions-to-common-scenarios-when-using-uitextfield-on-ios/#handling-multiple-text-fields
-- Brukte dette git-repoet som en referanse til å få UITextFieldDelegate til å fungere når man har flere textfields tilgjengelig i en ViewController.

- https://stackoverflow.com/questions/38274115/ios-swift-mapkit-custom-annotation
-- Brukte StackOverflow-spørsmålet som en referanse til å sette opp MapKit til å vise en Custom Pin, som inneholdt bildene til brukerne fra APIet.

- https://stackoverflow.com/questions/30262269/custom-marker-image-on-swift-mapkit
-- Brukte denne som en referanse til å lage en Custom Annotation til Map.

- https://gist.github.com/sajjadsarkoobi/9376dfee0f63e9da3483c1363dfa9078
-- Brukte denne klassen, ettersom postcode verdien fra APIet kunne enten være en String eller Int. Det finnes nok en løsning på denne problemstillingen, men ettersom dette funket slik jeg ønsket valgte jeg å beholde denne custom koden skrevet av noen andre.

- https://stackoverflow.com/questions/24056205/how-to-use-background-thread-in-swift?rq=1
-- Brukte svaret på dette stackoverflow-spørsmålet til å kjøre image-fetching av annotations på en annen tråd, for å redusere lag på Main Thread ettersom mappet lagget veldig da man skulle fetche bilder i mens man scrollet over mappet.

### Annet

- Vedlagt på Wiseflow ligger versjon av Xcode og Swift, men legger det ved her også:
-- Xcode versjon: Version 13.1 (13A1030d)
-- Swift Language Version: Swift 5 
