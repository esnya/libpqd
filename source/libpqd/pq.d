module libpqd.pq;

public import derelict.pq.pq;

shared static this() {
    DerelictPQ.load();
}