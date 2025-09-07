import uvicorn
from fastapi import FastAPI, Query
from async_solver import get_turnstile_token

app = FastAPI(title="Turnstile Solver API", version="1.0")

@app.get("/solve")
async def solve_turnstile(
    url: str = Query(..., description="Target page URL"),
    sitekey: str = Query(..., description="Cloudflare Turnstile sitekey"),
    action: str = Query(None, description="Optional Turnstile action"),
    cdata: str = Query(None, description="Optional Turnstile cdata"),
    debug: bool = Query(False, description="Enable debug logs"),
    browser_type: str = Query("chromium", description="Browser type (chromium/chrome/msedge/camoufox)"),
):
    # Default headless=True with useragent pre-set
    useragent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.9508.139 Safari/537.36"
    result = await get_turnstile_token(
        url=url,
        sitekey=sitekey,
        action=action,
        cdata=cdata,
        debug=debug,
        headless=True,
        useragent=useragent,
        browser_type=browser_type,
    )
    return result


if __name__ == "__main__":
    uvicorn.run("api_server:app", host="0.0.0.0", port=7860, reload=False)
