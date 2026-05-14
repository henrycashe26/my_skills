# Motion

Animation should communicate meaning, not decorate. The bar for adding motion is: "does this help the user understand what happened?"

```typescript
// Good use of motion: helps user track where the panel came from
<AnimatePresence>
  {isOpen && (
    <motion.div
      initial={{ x: '100%' }}
      animate={{ x: 0 }}
      exit={{ x: '100%' }}
      transition={{ type: 'spring', damping: 30, stiffness: 300 }}
      className="fixed right-0 top-0 h-full w-80 bg-white shadow-xl"
    >
      {content}
    </motion.div>
  )}
</AnimatePresence>

// Subtle fade for content appearing
<motion.div
  initial={{ opacity: 0, y: 4 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.15 }}
>
  {content}
</motion.div>
```

**Duration guide:**
- Micro-interactions (button press, checkbox toggle): 100–150ms
- Panel / drawer open/close: 200–250ms
- Modal appear: 150–200ms
- Page transitions: 200–300ms
- Anything over 400ms feels slow unless it is a deliberate loading animation
