# What is ReplaySubject?
**Well Replay subject is type of subject which is used to set a buffer for the future emits and it store value in its buffer to emit it when necessory**
## Here are a few examples
1. To download the image by using the URL session and then emitting the events whenever we want.
2. PublishSubject did not considered as the reply subject since it only provides upcoming events after the subscription and on the subscription is does not provide anything. While **BehaviourSubject** and **Variable** subject are single reply subjects which means on subscription these are who provides the most recent **event**. But **what to do to get according to our needs and upto particular no of future emits?**
3. Let's dig into the code and find the real example. **Well I want to push event for a string change 5 times and want to get last 4 events before the subscription?** is it possible by using other two **BehaviourSubject** or **Variable** *No it's* **not** and it's only possible by using the ReplySubject since it have the buffer size.😜

 Coding Example
-
        let replaySub = ReplaySubject<String>.create(bufferSize: 4)             
        replaySub.on(.next("(pre) Event 1"))
        replaySub.on(.next("(pre) Event 2"))
        replaySub.on(.next("(pre) Event 3"))
        replaySub.on(.next("(pre) Event 4"))
        replaySub.on(.next("(pre) Event 5"))             
        replaySub.subscribe({ //replays the 4 events in memory (2-5)
          print("line: \(#line)", "event: \($0)")
        })
        .disposed(by: self.disposebag)`

Let's see the output **(Note)** We have subscribed right after calling the next on the subscriber.
### OutPut
    line: 50 event: next((pre) Event 2)
    line: 50 event: next((pre) Event 3)
    line: 50 event: next((pre) Event 4)
    line: 50 event: next((pre) Event 5)
