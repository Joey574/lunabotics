import heapq
import time
import random

def djt(graph,start,end):
    #Input: Link dictionary, start index, end index
    
    #First: Initialize distance set
    distances = {a:float("inf") for a in graph}
    distances["params"] = graph["params"]
    distances[start] = 0
    
    #Next: initialize priority queue of unvisited nodes
    prioq = [(0,start)]
    
    #Main run:
    while prioq:
        #Current distance, current node is the shortest-distance element of prioq
        currd,currn = heapq.heappop(prioq)
        
        #When we hit the end node, return the whole thing
        if currn == end:
            return distances
        
        #If we've already seen a shorter path, disregard
        if currd > distances[currn]:
            continue
        
        #Otherwise:
        for neighbor,weight in graph[currn]:
            #Compute new distance
            distance = currd + weight
            
            #If new distance is shorter, update and push to heap
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                heapq.heappush(prioq, (distance,neighbor))

    return distances

def optimistic(graph,start,end):
    #Input: Link dictionary, start index, end index
    pathdir = {a:0 for a in graph}
    pathdir["params"] = graph["params"]
    currn = start
    index = 0
    while True:
        opdir = direction(currn,end)
        if opdir == (0,0):
            return pathdir
        else:
            for a in graph[currn]:
                if a[0] == pointdir(currn,opdir):
                    if a[1] < 100:
                        index += 1
                        pathdir[a[0]] = index
                        currn = a[0]
                    else:
                        index += 1
                        newdest = pointdir(currn,rr(opdir))
                        if newdest not in graph:
                            newdest = pointdir(currn,rl(opdir))
                        pathdir[newdest] = index
                        currn = newdest
    return pathdir
                        
    
    

def direction(p1,p2):
    p1c = [int(a) for a in p1.split(",")]
    p2c = [int(a) for a in p2.split(",")]
    if p1c[0] == p2c[0]:
        outx = 0
    elif p1c[0] < p2c[0]:
        outx = 1
    else:
        outx = -1
    if p1c[1] == p2c[1]:
        outy = 0
    elif p1c[1] < p2c[1]:
        outy = 1
    else:
        outy = -1
    return (outx,outy)

def pointdir(p1,guess):
    p1de = [int(a) for a in p1.split(",")]
    return "{},{}".format(guess[0] + p1de[0],guess[1] + p1de[1])

def rl(direction):
    return (qs(direction[0]-direction[1]),qs(direction[0]+direction[1]))

def rr(direction):
    return (qs(direction[0]+direction[1]),qs(direction[1]-direction[0]))

def qs(num):
    return (num > 0) - (num < 0)

def gridgraph(x,y,obslist = []):
    outdict = {"params":[x,y]}
    for a in range(x):
        for b in range(y):
            pointname = "{},{}".format(a,b)
            pointlist = []
            for c in range(max(a-1,0),min(a+2,x)):
                for d in range(max(b-1,0),min(b+2,y)):
                    if c != a or b != d:
                        nname = "{},{}".format(c,d)
                        if nname in obslist:
                            pointlist.append([nname,100])
                        elif pointname in obslist:
                            pointlist.append([nname,100])
                        elif c != a and d != b:
                            pointlist.append([nname,1.41])
                        else:
                            pointlist.append([nname,1])
            outdict[pointname] = pointlist
    return outdict

def testgrid(x,y,obsnum):
    #Create test grid size x,y with obsnum randomly-placed obstacles
    obslist = []
    for a in range(int(obsnum)):
        randobs = "{},{}".format(random.randint(0,x),random.randint(0,y))
        done = False
        while not done:
            if randobs != "0,0" and randobs != "{},{}".format(x,y):
                obslist.append(randobs)
                done = True
            else:
                randobs = "{},{}".format(random.randint(0,x),random.randint(0,y))
    return gridgraph(x,y,obslist)

def gridvis(graph):
    for a in range(graph["params"][0]):
        line = ""
        for b in range(graph["params"][1]):
            pointname = "{},{}".format(a,b)
            line += "{:>4}".format(graph[pointname])
        print(line)

def timetest(start,end,inc):
    runlist = []
    current = start
    while current <= end:
        #Run 5 trials with each, get total runtime
        start1 = time.time()
        for a in range(5):
            tempgrid = testgrid(current,current,5)
            djt(tempgrid,"0,0","{},{}".format(current-1,current-1))
        end1 = time.time()
        start2 = time.time()
        for a in range(5):
            tempgrid = testgrid(current,current,5)
            endval = current-1
            optimistic(tempgrid,"0,0","{},{}".format(endval,endval))
        end2 = time.time()
        
        runlist.append("Size {}, dj {}, opt {}".format(current,end1-start1,end2-start2))
        current += inc
    return runlist

#runs = timetest(100,150,5)

#for a in runs:
#    print(a)