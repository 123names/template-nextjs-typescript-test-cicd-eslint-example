import { render, screen } from "@testing-library/react";
import { Hello } from "../components/Hello";

test("Check the rendering of component", () => {
  render(<Hello />);
  const myComponent = screen.getByText(/Hello/);
  expect(myComponent).toBeInTheDocument();
});
