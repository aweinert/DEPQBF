import CDEPQBF

public enum QuantifierType {
    case exists
    case undef
    case forall
    
    func toInternal() -> QDPLLQuantifierType {
        switch self {
        case .exists: return QDPLL_QTYPE_EXISTS
        case .undef: return QDPLL_QTYPE_UNDEF
        case .forall: return QDPLL_QTYPE_FORALL
        }
    }
}

public class DEPQBF {
    let solver : OpaquePointer
    
    public init() {
        self.solver = qdpll_create()
    }
    
    deinit {
        qdpll_delete(solver)
    }
    
    public func configure(_ configString : String) -> String? {
        let retVal = configString.withCString {
            qdpll_configure(solver, UnsafeMutablePointer(mutating: $0))
        }
        guard let _retVal = retVal else {
            return nil
        }
        return String(cString: _retVal)
    }
    
    public func add(_ variable: Int) {
        qdpll_add(solver, Int32(variable))
    }
    
    public func push() {
        qdpll_push(solver)
    }
    
    public func pop() {
        qdpll_pop(solver)
    }
    
    public func newScopeAtNesting(_ qType : QuantifierType, _ nesting : Int) -> Int {
        return Int(qdpll_new_scope_at_nesting(solver, qType.toInternal(), UInt32(nesting)))
    }
    
    /// - returns:
    ///   True if the formula is satisfiable, False if it is unsatisfiable, Nil if satisfiability is unknown
    public func sat() -> Bool? {
        switch qdpll_sat(solver) {
        case QDPLL_RESULT_SAT: return true
        case QDPLL_RESULT_UNSAT: return false
        default: return nil
        }
    }
    
    public func reset() {
        qdpll_reset(solver)
    }
}

