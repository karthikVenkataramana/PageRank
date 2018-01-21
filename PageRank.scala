/*
Author: Karthik Venkataramana Pemmaraju
Date: 04/28/2017
Description: Performs Page rank algorithm on Wikipedia example Graph and also on a randomly created Graph.
Compilation: scalac PageRank.scala
Execution: scala PageRank
*/

import scala.io.StdIn.readInt 
import scala.collection.mutable.ArrayBuffer
import scala.util.Random

case class Node(val pN:String){
    var pageName:String = pN
    var pageRank:Double = 0.0 
    var incomingNodes:ArrayBuffer[Node] = ArrayBuffer.empty
    var outlinks:Int = 0
}
object PageRank{
    var WikiNodes = new ArrayBuffer[Node]()
    var nodesWithNoOutlinks = new ArrayBuffer[Node]()
    var RandomNodes = new ArrayBuffer[Node]()

    val A = new Node("A") ; WikiNodes+=A
    val B = new Node("B") ; WikiNodes+=B
    val C = new Node("C") ; WikiNodes+=C
    val D = new Node("D") ; WikiNodes+=D
    val E = new Node("E") ; WikiNodes+=E
    val F = new Node("F") ; WikiNodes+=F
    val G = new Node("G") ; WikiNodes+=G
    val H = new Node("H") ; WikiNodes+=H
    val I = new Node("I") ; WikiNodes+=I
    val J = new Node("J") ; WikiNodes+=J
    val K = new Node("K") ; WikiNodes+=K
    
    def updateNodes(){
        val initialRank:Double = 1 / WikiNodes.length.toDouble 
        for(node <- WikiNodes){
            if(node.outlinks==0)
                nodesWithNoOutlinks+=node
            node.pageRank = initialRank    
        }

         for(node <- nodesWithNoOutlinks){
            for(wikiNode <- WikiNodes){
                  if(!(node == wikiNode))
                    setEdge(node,wikiNode) 

            }
            node.outlinks = WikiNodes.length
        }
           
    }

    def initializeWikiGraph(){
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
      updateNodes
    }
    
    def initializeRandomGraph(seed:Int,numNodes:Int,numOutlinks:Int){
        var x:Node = null
        var random = new Random(seed)
        var randNumber = 0
        for(i <- 0 to (numNodes-1)){
            x = new Node(i.toString)
            RandomNodes += x
        }
        
        val initialRank:Double = 1 / RandomNodes.length.toDouble 
        
        for(node <- RandomNodes){
            var j = 0
            while(j < numOutlinks){
                 randNumber = random.nextInt(numNodes)
                 if( (!(node == RandomNodes(randNumber))) && (!(edgeExists(node,RandomNodes(randNumber),RandomNodes))) ){
                    setEdge(node,RandomNodes(randNumber))
                    j = j + 1
                 }
            }
            node.pageRank = initialRank
            j = 0
        } 
    }
    
    def edgeExists(source : Node, destination : Node, listNodes:ArrayBuffer[Node]):Boolean = {
        if(destination.incomingNodes.contains(source))
            return true
        return false    
    }

    def calculateRank(source:Node,nodesGraph:ArrayBuffer[Node]){
        var page_rank:Double = 0.0
        var rank:Double = 0.0
        for(node <- source.incomingNodes){
            page_rank += (node.pageRank / node.outlinks)
        }
        if(nodesWithNoOutlinks.contains(source)){
            rank = source.pageRank / source.outlinks
            page_rank = (1.0 - 0.85) / nodesGraph.length + (0.85)*(page_rank + rank)
        }
        else
            page_rank = (1.0 - 0.85) / nodesGraph.length + (0.85)*(page_rank)
        updateRank(source,page_rank)
    }
    
    def updateRank(source:Node,page_rank:Double){
        source.pageRank = page_rank
    }

    def computePageRanks(nodesGraph:ArrayBuffer[Node]){
        var i:Int = 0
        while(i < 100){
            for(node <- nodesGraph){
                calculateRank(node,nodesGraph)
            }
            i = i + 1
        }
    }
    
    def printRanks(nodesGraph:ArrayBuffer[Node]){
        println("After 100 iterations:- ")
        for(node <- nodesGraph)
        println("Page rank of "+ node.pageName+" is "+ node.pageRank*100 +" %")
    }

    def sumOfAllRanks(nodesGraph:ArrayBuffer[Node]){
        var sum:Double = 0.0
        for(node <- nodesGraph)
        sum += node.pageRank
        println("\nSum of all Pageranks of Graph with "+ nodesGraph.length + " nodes is "+sum)
    }

    def setEdge(source:Node,destination:Node){
          source.outlinks += 1
          destination.incomingNodes += source
    }

    def main(args:Array[String]){
      println("/*************************************************************")
      var start:Double = System.nanoTime()
      initializeWikiGraph
      computePageRanks(WikiNodes)
      var end:Double = System.nanoTime()
      var timeElapsed:Double  = (end-start) / 1000000000
      println("Printing Page Ranks for Wikipedia example\n")
      printRanks(WikiNodes)
      sumOfAllRanks(WikiNodes)
      println("\nTime taken to compute Wikipedia graph page ranks is "+timeElapsed+" seconds.")
      println("***************************************************************/\n")
      print("\nEnter a random seed (Any Integer): ")
      var seed:Int = readInt
      print("How many nodes do you want in your graph? ")
      var numNodes:Int = readInt
      print("\nHow many number of Outgoing links for each node? ")
      var numOutlinks:Int = readInt  
      println("/*************************************************************")
      start = System.nanoTime()
      initializeRandomGraph(seed,numNodes,numOutlinks)
      computePageRanks(RandomNodes)
      end =  System.nanoTime()
      timeElapsed = (end - start) / 1000000000
      printRanks(RandomNodes)
      sumOfAllRanks(RandomNodes)
      println("\nTime taken to compute Random node graph page ranks is "+timeElapsed+" seconds.")
      println("***************************************************************/\n")
      
     }   
}