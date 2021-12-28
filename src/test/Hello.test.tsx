import { render, screen } from "@testing-library/react";
import { Hello } from "../components/Hello";

// check eslint rule installed or not
// fit("Check the rendering of component", () => {
//   render(<Hello />);
//   const myComponent = screen.getByText(/Hello/);
//   expect(myComponent).toBeInTheDocument();
// });

test("Check the rendering of component", () => {
  render(<Hello />);
  const myComponent = screen.getByText(/Hello/);
  // screen.debug();
  expect(myComponent).toBeInTheDocument();
});
