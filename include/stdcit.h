#ifndef STD_H
#define STD_H

namespace cit {
  typedef struct standardLib {
    //
  } stdlib;
  void io(int argv, int argc, index, name) {
    // ..
  }
  class CitStd {
  public:
    CitStd();
    CitStd(CitStd &&) = default;
    CitStd(const CitStd &) = default;
    CitStd &operator=(CitStd &&) = default;
    CitStd &operator=(const CitStd &) = default;
    ~CitStd();
  
  private:
    
  };
  
  CitStd::CitStd() {
  }
  
  CitStd::~CitStd() {
  }
}

#endif // STD_H
