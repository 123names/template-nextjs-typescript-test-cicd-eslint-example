import { render } from "@testing-library/react";
import { Hello } from "../components/Hello";

test("Check the rendering of component", () => {
  render(<Hello />);
});
