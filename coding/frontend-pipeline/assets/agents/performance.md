Execute a frontend performance audit using the frontend-performance skill.

Skill path: [path-to-skill]/frontend-performance/
Codebase: [path or URL]

Your output should cover:
1. Bundle size estimate and known large dependencies
2. Any virtualization gaps (unvirtualized long lists)
3. Obvious render performance issues (unnecessary re-renders, missing memoization)
4. Network patterns (waterfalls, missing caching, no staleTime)
5. Image handling
6. Top 5 performance wins ranked by impact, with implementation sketch

Save findings to: [workspace]/agent-performance.md
