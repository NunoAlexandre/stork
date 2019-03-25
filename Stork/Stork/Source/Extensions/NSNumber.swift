import Foundation

extension NSNumber {

  // An NSNumber might contain different types that get
  // coerced to/from Bool. To know if an NSNumber is
  // objectively a Bool, check if it's type is the same
  // as of an NSNumber built from a Bool.
  // See the following stackOverflow thread to learn more
  // about this problem: http://tinyurl.com/y2u9zmxw
  public func isBool() -> Bool {
    return type(of: self) == type(of: NSNumber(value: true))
  }
}
