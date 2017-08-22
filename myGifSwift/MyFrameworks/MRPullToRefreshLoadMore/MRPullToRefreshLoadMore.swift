import UIKit

@objc public protocol MRPullToRefreshLoadMoreDelegate {
    func viewShouldRefresh(scrollView:UIScrollView)
    func viewShouldLoadMore(scrollView:UIScrollView)
}

public class MRPullToRefreshLoadMore:NSObject {

    public var scrollView:UIScrollView?
    public var pullToRefreshLoadMoreDelegate:MRPullToRefreshLoadMoreDelegate?
    public var enabled:Bool = true
    public var startingContentInset:UIEdgeInsets?
    public var pullToRefreshViewState:ViewState = ViewState.Normal
    public var loadMoreViewState:ViewState = ViewState.Normal
    
    public var arrowImage: CALayer?
    public var activityView: UIActivityIndicatorView?
    public var indicatorPullToRefresh = IndicatorView()
    public var indicatorLoadMore = IndicatorView()
    
    public var indicatorTintColor: UIColor? {
        didSet {
            indicatorLoadMore.indicatorTintColor = (indicatorTintColor ?? UIColor.red)
            indicatorPullToRefresh.indicatorTintColor = (indicatorTintColor ?? UIColor.red)
        }
    }

    var indicatorSize: CGSize = CGSize.init(width: 30.0, height: 30.0)
    public var textColor:UIColor = UIColor.red
    
    public enum ViewState {
        case Normal
        case LoadingHorizontal
        case LoadingVertical
        case ReadyHorizontal
        case ReadyVertical
    }
    
    public enum Drag {
        case Left
        case Top
        case Right
        case Bottom
        case None
    }
    
    public func initWithScrollView(scrollView:UIScrollView) {
        scrollView.addSubview(indicatorPullToRefresh)
        scrollView.addSubview(indicatorLoadMore)
                
        self.scrollView = scrollView
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        startingContentInset = scrollView.contentInset
        //print(startingContentInset)
        self.enabled = true
        setPullState(state: ViewState.Normal)
        setLoadMoreState(state: ViewState.Normal)
    }
    
    public func setLoadMoreState(state:ViewState) {
        loadMoreViewState = state
        
        switch (state) {
        case ViewState.ReadyVertical, ViewState.ReadyHorizontal:
            scrollView!.contentInset = self.startingContentInset!
            indicatorLoadMore.setAnimating(animating: false)
            
        case ViewState.Normal:
            indicatorLoadMore.setAnimating(animating: false)
            UIView.animate(withDuration: 0.2, animations: {
                self.scrollView!.contentInset = self.startingContentInset!
            })
        case ViewState.LoadingVertical:
            indicatorLoadMore.setAnimating(animating: true)
            scrollView!.contentInset = UIEdgeInsetsMake(0.0, 0.0, 60.0, 0.0)
        case ViewState.LoadingHorizontal:
            indicatorLoadMore.setAnimating(animating: true)
            scrollView!.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 60.0)
        }
    }
    
    
    public func setPullState(state:ViewState) {
        pullToRefreshViewState = state
        
        switch (state) {
        case ViewState.ReadyHorizontal, ViewState.ReadyVertical:
            scrollView!.contentInset = self.startingContentInset!
            indicatorPullToRefresh.setAnimating(animating: false)
        
        case ViewState.Normal:
            indicatorPullToRefresh.setAnimating(animating: false)
            UIView.animate(withDuration: 0.2, animations: {
                self.scrollView!.contentInset = self.startingContentInset!
            })
        
        case ViewState.LoadingHorizontal:
            indicatorPullToRefresh.setAnimating(animating: true)
            scrollView!.contentInset = UIEdgeInsetsMake(0.0, 60.0, 0.0, 0.0)
        
        case ViewState.LoadingVertical:
            indicatorPullToRefresh.setAnimating(animating: true)
            scrollView!.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    //}
    //override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch (keyPath) {
        case .some("contentOffset"):
            
            if (enabled) {
                
                
                // HORIZONTAL SCROLL
                let diff_x_end = scrollView!.contentOffset.x + scrollView!.bounds.width - scrollView!.contentSize.width
                let diff_x_start = 0 - scrollView!.contentOffset.x
                
                let diff_y_end = scrollView!.contentOffset.y + scrollView!.bounds.height - scrollView!.contentSize.height
                let diff_y_start = 0 - scrollView!.contentOffset.y
                
                var drag:Drag = .None
                
                // pull to refresh
                if diff_x_start > 0.0 {
                    drag = .Left
                } else if diff_y_start > 0.0 {
                    drag = .Top
                } else if diff_x_end > 0.0 {
                    drag = .Right
                } else if diff_y_end > 0.0 {
                    drag = .Bottom
                }
                
                switch(drag) {
                case .Top:
                    indicatorPullToRefresh.frame = CGRect.init(x: scrollView!.bounds.width/2 - indicatorSize.width/2, y: -scrollView!.bounds.origin.y - 45 + scrollView!.contentOffset.y, width: indicatorSize.width, height: indicatorSize.height)
                case .Left:
                    indicatorPullToRefresh.frame = CGRect.init(x: -45, y: scrollView!.bounds.height/2-15, width: indicatorSize.width, height: indicatorSize.height)
                case .Bottom:
                    //indicatorLoadMore.frame = CGRectMake(scrollView!.bounds.width/2 - indicatorSize.width/2, 15 + scrollView!.contentSize.height, indicatorSize.width, indicatorSize.height)
                    indicatorLoadMore.frame = CGRect.init(x: scrollView!.bounds.width/2 - indicatorSize.width/2, y: 15 + scrollView!.contentSize.height, width: indicatorSize.width, height: indicatorSize.height)
                case .Right:
                    //indicatorLoadMore.frame = CGRectMake(scrollView!.contentSize.width + 15, scrollView!.bounds.height/2 - 15, indicatorSize.width, indicatorSize.height)
                    indicatorLoadMore.frame = CGRect.init(x: scrollView!.contentSize.width + 15, y: scrollView!.bounds.height/2-15, width: indicatorSize.width, height: indicatorSize.height)
                default: break
                }
                
                
                if (scrollView!.isDragging) {
                    switch(drag) {
                    case .Top:
                        switch(pullToRefreshViewState) {
                        case ViewState.ReadyVertical:
                            indicatorPullToRefresh.interactiveProgress = diff_y_start / 130.0
                            if (diff_y_start < 65.0) {
                                setPullState(state: ViewState.Normal)
                            }
                        case ViewState.Normal:
                            indicatorPullToRefresh.interactiveProgress = diff_y_start / 130.0
                            if (diff_y_start > 65.0) {
                                setPullState(state: ViewState.ReadyVertical)
                            }
                        default: break
                        }
                        
                    case .Left:
                        switch(pullToRefreshViewState) {
                        case ViewState.ReadyHorizontal:
                            indicatorPullToRefresh.interactiveProgress = diff_x_start / 130.0
                            if (diff_x_start < 65.0) {
                                setPullState(state: ViewState.Normal)
                            }
                        case ViewState.Normal:
                            indicatorPullToRefresh.interactiveProgress = diff_x_start / 130.0
                            if (diff_x_start > 65.0) {
                                setPullState(state: ViewState.ReadyHorizontal)
                            }
                        default: break
                        }
                    case .Bottom:
                        switch(loadMoreViewState) {
                        case ViewState.ReadyVertical:
                            indicatorLoadMore.interactiveProgress = diff_y_end / 130.0
                            if (diff_y_end < 65.0) {
                                setLoadMoreState(state: ViewState.Normal)
                            }
                        case ViewState.Normal:
                            indicatorLoadMore.interactiveProgress = diff_y_end / 130.0
                            if (diff_y_end > 65.0) {
                                setLoadMoreState(state: ViewState.ReadyVertical)
                            }
                        default: break
                        }
                    case .Right:
                        switch(loadMoreViewState) {
                        case ViewState.ReadyHorizontal:
                            indicatorLoadMore.interactiveProgress = diff_x_end / 130.0
                            if (diff_x_end < 65.0) {
                                setLoadMoreState(state: ViewState.Normal)
                            }
                        case ViewState.Normal:
                            indicatorLoadMore.interactiveProgress = diff_x_end / 130.0
                            if (diff_x_end > 65.0) {
                                setLoadMoreState(state: ViewState.ReadyHorizontal)
                            }
                        default: break
                        }
                    default: break
                    }
                } else {
                    // pull to refresh
                    if (pullToRefreshViewState == ViewState.ReadyHorizontal || pullToRefreshViewState == ViewState.ReadyVertical) {
                        UIView.animate(withDuration: 0.2, animations: {
                            if self.pullToRefreshViewState == ViewState.ReadyHorizontal {
                                self.setPullState(state: ViewState.LoadingHorizontal)
                            } else {
                                self.setPullState(state: ViewState.LoadingVertical)
                            }
                        })
                        
                        if let pullToRefreshLoadMoreDelegate = pullToRefreshLoadMoreDelegate {
                            pullToRefreshLoadMoreDelegate.viewShouldRefresh(scrollView: scrollView!)
                        }
                    }
                    
                    // load more
                    if (loadMoreViewState == ViewState.ReadyHorizontal || loadMoreViewState == ViewState.ReadyVertical) {
                        UIView.animate(withDuration: 0.2, animations: {
                            if self.loadMoreViewState == ViewState.ReadyHorizontal {
                                self.setLoadMoreState(state: ViewState.LoadingHorizontal)
                            } else {
                                self.setLoadMoreState(state: ViewState.LoadingVertical)
                            }
                        })
                        
                        if let pullToRefreshLoadMoreDelegate = pullToRefreshLoadMoreDelegate {
                            pullToRefreshLoadMoreDelegate.viewShouldLoadMore(scrollView: scrollView!)
                        }
                    }
                }
                
                //print(loadMoreViewState)
            }
        default:
            break
        }
    }
}

public class MRTableView:UITableView {
    
    public var pullToRefresh:MRPullToRefreshLoadMore = MRPullToRefreshLoadMore()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pullToRefresh.initWithScrollView(scrollView: self)
    }
    
    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame, style:style)
        pullToRefresh.initWithScrollView(scrollView: self)
    }
}

public class MRCollectionView:UICollectionView {
    
    public var pullToRefresh:MRPullToRefreshLoadMore = MRPullToRefreshLoadMore()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pullToRefresh.initWithScrollView(scrollView: self)
    }
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame:frame, collectionViewLayout:layout)
        pullToRefresh.initWithScrollView(scrollView: self)
    }
}
