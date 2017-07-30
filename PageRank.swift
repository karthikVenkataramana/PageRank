/*
Author: Karthik Venkataramana Pemmaraju
Date: 04/27/2017
Description: This program performs Pagerank algorithm for Wikipedia example and a Randomly generated graph
Execution: swift PageRank.swift
Compiled and tested using Swift 3.2 version, Ubuntu(12.04 lt) and VS Code editor.
For Online execution: https://swift.sandbox.bluemix.net/#/repl/59023bfcd5760a4bd910d330
*/

import Foundation
import Dispatch

/*
Type: Class
Description: Defines any Node in a graph
*/

class Node:Equatable{         
    var Name:String
    var Outlinks:Int
    var IncomingNodes:[Node]
    var PageRank:Double
    init(_ Name:String){ // Similar to Constructor
        self.Name = Name
        self.Outlinks=0
        self.IncomingNodes=[]
        self.PageRank=0.0  
    } 
}

/*
Defines equality for class instances. Used by contains() method.
*/

func == (lhs: Node, rhs: Node) -> Bool {
      return lhs.Name == rhs.Name
}

/*
Type: Function 
Parameters: 
1) @Source - a Node instance in the graph
2) @Destination - a Node instance in the graph
Description: Sets an edge from source to destination
Update outgoing links from source and Incoming links to destination
*/

func setEdge(_ source:Node,_ destination:Node){
source.Outlinks = source.Outlinks + 1
destination.IncomingNodes.append(source)
}

/*
Global Arrays of WikiNodes,Random Graph nodes and nodes with no outgoing links.
*/

var WikiNodes:[Node]=[]
var Nodes_With_No_Outlinks_Of_Wiki:[Node]=[]
var RandomNodes:[Node]=[] 

/*
Type: Function
Parameters: None
Description:
1) Link nodes with no outgoing links to all nodes.
2) Sets up initial ranks.
*/

func updateNodes(){
let totalNodes = Double(WikiNodes.count)
let initialRank:Double = (1/totalNodes)
// Step 1: Getting all nodes with no outlinks into our data structure and setting up initial rank.
for node in WikiNodes{
 if(node.Outlinks==0){
 Nodes_With_No_Outlinks_Of_Wiki.append(node)
 }
node.PageRank = initialRank 
}
// Step 2: Then, set up an edge to every other node
for no_Out_node in Nodes_With_No_Outlinks_Of_Wiki{
   for node in WikiNodes{
       if(no_Out_node !== node){
           setEdge(no_Out_node,node)
       }
   }  
   no_Out_node.Outlinks = WikiNodes.count // This is important. Setting number of outlinks to everyone.
}
}

/*
Parameters: @List of Nodes
Description: Computes ranks for a given set of nodes in graph 
Internally, calls calculate rank which in turn does it for each node.
*/

func computeRanks(_ listNodes:[Node]){
    var i = 0
    while(i < 99){               // Perform 100 iterations.
    for node in listNodes{
        calculateRank(node,listNodes)    
    } 
    i = i+1
    }
}

/*
Returns sum of pageranks of all nodes in (listNodes)
*/

func sumOfPageRanks(_ listNodes:[Node]){
    var x:Double = 0
    for node in listNodes{
        x = x + node.PageRank
    }
    print("\nSum of page ranks of \(listNodes.count) nodes after 100 iterations is \(x)")
}

/*
Prints ranks for given list of nodes
*/

func printRanks(_ list_Of_Nodes:[Node]){
    for node in list_Of_Nodes{
        print("Page rank of Node '\(node.Name)' is \(node.PageRank * 100)%")
    }
}

/*
Parameters: 
@node - Node for which page rank is being calculated.
@listNodes - list of all Nodes in Graph G.
Description: Calculates the page rank  for a given source.
*/

func calculateRank(_ node:Node,_ listNodes:[Node]){
    let incomingNodes:[Node] = node.IncomingNodes
    var rank:Double = 0
    var pagerank:Double = 0
    for inNode in incomingNodes{
     pagerank = pagerank + (inNode.PageRank / (Double(inNode.Outlinks)))
    }
    if(Nodes_With_No_Outlinks_Of_Wiki.contains(node)){
        rank = (node.PageRank) / (Double(node.Outlinks))
        pagerank = (1-0.85) / Double(listNodes.count) + Double(0.85 * (pagerank+rank))
      }
     else{
        pagerank = (1-0.85) / Double(listNodes.count) + Double(0.85 * pagerank)
    }
    updateRank(node,pagerank)
}

/*
Description: Updates the rank for a given node.
*/
func updateRank(_ node:Node,_ rank:Double){
    node.PageRank = rank
}
 

/*
Initializing the Wiki data
*/

func initializeWikiGraph(){
let A = Node("A"); WikiNodes.append(A)
let B = Node("B"); WikiNodes.append(B)
let C = Node("C"); WikiNodes.append(C)
let D = Node("D"); WikiNodes.append(D)
let E = Node("E"); WikiNodes.append(E)
let F = Node("F"); WikiNodes.append(F)
let G = Node("G"); WikiNodes.append(G)
let H = Node("H"); WikiNodes.append(H)
let I = Node("I"); WikiNodes.append(I)
let J = Node("J"); WikiNodes.append(J)
let K = Node("K"); WikiNodes.append(K)
setEdge(D, A)
setEdge(D, B)
setEdge(B, C)
setEdge(C, B)
setEdge(E, D)
setEdge(E, B)
setEdge(E, F)
setEdge(F, E)
setEdge(F, B)
setEdge(G, B)
setEdge(G, E)
setEdge(H, B)
setEdge(H, E)
setEdge(I, B)
setEdge(I, E)
setEdge(J, E)
setEdge(K, E) 
updateNodes()
}

/*
Checks if an edge is present in a graph or not.
Logic is to check if source is present in destination incoming nodes.
*/
func edgeExists(_ source:Node,_ destination:Node) -> Bool{
 let incomingNodes:[Node] = destination.IncomingNodes
 if(incomingNodes.contains(source)){
     return true
 }
 else{
     return false
 }
}

/*
Initializes a random graph with given seed, Number of nodes and number of outlinks
*/

func initializeRandomGraph(_ seed:Int,_ numNodes:Int,_ numOutlinks:Int){
var i:Int = 1
var x:Node
while(i<=numNodes){ // Create our Graph with number of nodes sent in as argument
x = Node(String(i))
RandomNodes.append(x)
i = i+1
}
srandom(UInt32(seed)) // Pick an user input seed. Should call srandom() function
let initialRank:Double = 1 / Double(RandomNodes.count)
for node in RandomNodes{
    // Pick numOutlinks as many random nodes and set edges
 var j:Int = 0
 var random:Int=0
 while(j<numOutlinks){
    random = generateRandomNumber(RandomNodes.count) 
    if((!edgeExists(node,RandomNodes[random])) && (node !== RandomNodes[random])){
        setEdge(node,RandomNodes[random])
        j = j+1
    } 
 }
 node.PageRank = initialRank
}   
}

/*
 Description: A little Bit of explanation is required for this function.
 In linux there is no support for arc4random_uniform function.
 So,falling back to good Old 'C' and borrowing random() for linux
*/

func generateRandomNumber(_ max:Int) -> Int{

var randomNumber:Int
#if os(Linux)
 randomNumber = Int(random() % max)
#else
 randomNumber = Int32(arc4random_uniform(max))
#endif  
return randomNumber
}

// Calling our main important functions.
var start = DispatchTime.now()
initializeWikiGraph()
computeRanks(WikiNodes)
var end = DispatchTime.now()
var nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
var seconds = Double(nanoTime) / 1_000_000_000
print("/**************************************************************")
print("Page Ranks of Wikipedia Graph \n")
printRanks(WikiNodes)
sumOfPageRanks(WikiNodes)
print("\nTime taken to compute Wikipedia Page Ranks is \(seconds) seconds")
print("**************************************************************/")
print("\nPlease enter seed value (Any integer)")
//let seed = readLine() 
print("\nPlease enter number of nodes in Random Graph")
//let numNodes = readLine()
print("\nPlease enter number of Outgoing links for each node in Random Graph")
//let outlinks = readLine()
print("/**************************************************************")
start = DispatchTime.now()
initializeRandomGraph(42,500,100)
computeRanks(RandomNodes)
end = DispatchTime.now()
nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
seconds = Double(nanoTime) / 1_000_000_000
print("\nPage Ranks of Random Graph Model \n ")
printRanks(RandomNodes)
sumOfPageRanks(RandomNodes)
print("\nTime taken to compute Random Node Graph Page Ranks is \(seconds) seconds")
print("**************************************************************/")
