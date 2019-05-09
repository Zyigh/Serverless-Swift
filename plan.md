# Serverless Swift

## Serverside Swift

### Scripts

Le mois dernier, on a vu les scripts Swift pour automatiser la gestion des traductions, aujourd'hui on va essayer d'aller plus loin avec Swift côté serveur !

Swift n'est pas le langage d'iOS, c'est le langage d'Apple. On peut créer tout un tas de programmes de plein de genre différent (command line exe, HTTP server...)

### Swift sur Linux && Docker

Swift est opensource et compile sur Ubuntu. On peut déployer sur n'importe quel serveur Ubuntu et donc facilement créer du code crossplateform : OSX et Ubuntu ! Il devient alors facile de le rendre portable grâce à Docker.

Plusieurs images Swift existent sur dockerhub, basée sur Ubuntu (notamment l'image officielle d'Apple). En plus de permettre la portabilité du code, on peut s'en servir pour tester du code sur Linux par exemple.

Swift devient dès lors une excellente alternative de langage pour des technologies actuelles porteuses

## Serverless

Le Serverless est une technologie montante. Tellement montante qu'elle fait partie des mots clés pour détecter la startup bullshit :
Blockchain, Machine Learning, IA, Cloud, Fullstack JS, Serverless...
Quand tous ces mots sont réunis dans la description d'une startup, c'est souvent mauvais signe...

Serverless reste néanmoins un terme marketing. On devrait parler de Function As A Service.

### FaaS

L'enjeu du FaaS est de définir des fonctions indépendantes, puis leur donner du sens en les chaînant dans un l'ordre que l'on veut.

Cela présente l'avantage d'avoir un code facilement modulable, et facile à faire évoluer. Si on a besoin de plus de finesse, on peut remplacer ou ajouter une fonction dans la chaîne par exemple. Tant que l'input géré et l'output restent les même, chaque action peut changer sans affecter le bon fonctionnement de la chaîne.

Serverless apporte beaucoup d'avantages :
* Microservices
* liberté de langage
* Paiement à l'utilisation
* Orienté évènement

### Programmation orientée évènements

Cela permet d'avoir un code qui "dort", qui attend un évènement avant de s'activer, de la même manière que l'interface graphique d'un OS attend qu'on clique sur un dossier pour l'ouvrir et afficher son contenu. Cela explique les coûts très faibles : le serveur ne travaille que quand il reçoit un évènement.

Cela est d'autant plus vrai avec Swift dont le compilateur permet de générer des exécutables qui demandent très peu de ressources, et XCode qui permet de controller les consommations CPU + RAM.

### Openwhisk : Swift 4.2 natif

Openwhisk est une solution FaaS sous license Apache 2.0 qui présente en plus un support natif de Swift 4.2 (Swift 5 à venir). Les fonctions y sont appelées actions. Elles sont composées d'une main fonction qui prends en paramètre les arguments (un json parsé en `[String: Any]`) et qui renvoie un tableau (`[String: Any]`) qui sera parsé en json :

```swift
func main(args: [String: Any]) -> [String: Any] {
    // Do Something
}
```

Hello World exemple, qui renvoie "Hello <name>" si on lui passe un nom en paramètre :
```swift
// hello.swift
func main(args: [String: Any]) -> [String: Any] {
    var name = "World"
    if let n = args["name"] as? String {
        name = n
    }
    
    return [
        "greetings": "Hello \(name) !"
    ]
}
```

On crée facilement l'action grâce au CLI `wsk` :
```bash
# Dans le répertoire de hello.swift
wsk action create helloSwift ./hello.swift
```

Et pour l'appeler, l'invoquer :
```bash
wsk action invoke -r helloSwift -p name Taylor
```

et le résultat :
```json
{
    "greetings": "Hello Taylor !"
}
```

Les flags utilisés :

* -r, --result  
    Bloque l'invocation pour attendre et afficher son résultat
* -p, --param KEY VALUE  
    Les paramètres que l'on passe à l'action parsés en json avant d'être envoyés à l'action
    
Cette approche qui permet de découper son code en petites fonctions très spécifiques permet une facilité de compréhension du code dans son ensemble. Le code devient très facile à aborder. Dans mon cas, étant junior, l'architecture est simple à comprendre : Il n'y a qu'une fonction; les problèmes rencontrés sont plus simple à aborder et donc résoudre puisque le cadre d'action est très clairement défini (le nom du fichier) et très réduit. 
 
### Codable

Devoir traiter du json se fait de manière beaucoup plus simple et lisible grâce au protocol Codable. Openwhisk supporte l'utilisation de Codable de manière totalement transparente, ce qui permet une expérience de développement beaucoup plus agréable. Exemple avec le Hello World :

```swift
struct Hello: Codable {
    let greetings: String
}

struct Person: Codable {
    let name: String?
}

func main(input: Person, respondWith: (Hello?, Error?) -> Void) -> Void {
    guard let name = input.name else {
        respondWith(Hello(greetings: "Hello World !"), nil)
    }
    
     respondWith(Hello(greetings: "Hello \(name) !"), nil)
}
```

Cela apporte énormément de clarté dans les inputs et les outputs qui sont l'essence du chainage des actions. 

### Chainer les actions

Chaîner des actions permet d'exécuter une suite d'actions dans un ordre précis. C'est à dire que chaque action va prendre en paramètre l'output de l'action appelé précédemment. Cela devient intéressant dès lors que l'on est confronté à des enjeux plus complexes que dire "Bonjour" à la personne qui rentre son nom. Sous openwhisk, une chaine d'actions s'appelle une séquence.

On rentre alors dans une organisation très souple. Chaque action peut-être utilisée dans autant de séquences que l'on souhaite. 

## Démo
