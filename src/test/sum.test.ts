import { sum } from "./sum";

test("Sum of 1+1 is 2", () => {
  const a: String = 2;
  expect(a).toBe(2);
  expect(sum(1, 1)).toBe(2);
});
