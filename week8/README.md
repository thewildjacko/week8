## Part 1 - Short answer questions.

a) Concurrency means doing **multiple**  things at once.

b) In Swift's concurrency, the term "main actor" is often used in place of **main thread**..

c) The main challenge of concurrent programming is that the **order** of operations can change.

d) URLSession is used to **fetch** data from a URL.

e) True or false: The @MainActor attribute can only be used on classes, not methods. **False**

f) True or False: A potential concurrency problem is when multiple code paths try to access and change the same state at the same time. **True**

g) The term often used to indicate when methods are not safe to use concurrently is **not thread-safe**.

h) You must provide an **identifier** for a background configuration so the system can reconstruct its sessions.

i) True or False: URLSession allows you to configure tasks to run in the foreground only. **False**

j) The three concrete subclasses of URLSessionTask are **default**, **ephemeral**, and **background**.

k) True or False: The OS will always strictly follow the priority you set for a task. **False**

l) By default, the system assumes your task has a **medium (0.5)** priority.

m) True or False: If a cached response is available, the URL loading system will always use it instead of fetching new data. **false, there are several different options for handling caches, including making a new request every time**

n) The Network Link Conditioner allows you to simulate different network **speeds** and conditions.
